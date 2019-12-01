//
//  TrendingViewController.swift
//  GiphyKin
//
//  Created by Kamal Maged on 2019-11-22.
//  Copyright © 2019 Kamal Maged. All rights reserved.
//
import UIKit
import CoreData

let giphyApiKey = "q0suMTvOXQaaTWUzhHMoy0qCEo0xZmKw"
let baseURLString = "https://api.giphy.com/v1/gifs"

class TrendingViewController: UIViewController {
    
    var giphyArray = [Gif]()

    private let trendingReuseIdentifier = "GiphyTrendingCell"
    @IBOutlet weak var trendingTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    var notFoundLabel = UILabel()
   
    let gifCoreData = GifCoreDataInterface()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trendingTableView.delegate = self
        trendingTableView.dataSource = self
        searchTextField.delegate = self
        guard let giphyTrendingURL = giphyTrendingURL() else {
            print(Error.invalidURL)
            return
        }
        giphyAPICall(url: giphyTrendingURL) {}
    }

}



// MARK: - DataSource and Delegates
extension TrendingViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, FavoriteButtonHandle {
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return giphyArray.count
        }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = trendingTableView.dequeueReusableCell(withIdentifier: trendingReuseIdentifier, for: indexPath) as! GiphyTrendingCell
            cell.delegate = self
            
            cell.gif = giphyArray[indexPath.row]
        
            cell.configureImage()
            return cell
        }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
        let activityIndicator = UIActivityIndicatorView(style: .medium)
          textField.addSubview(activityIndicator)
          activityIndicator.frame = textField.bounds
          activityIndicator.startAnimating()
        
        if textField.text == "" {
            guard let giphyTrendingURL = giphyTrendingURL() else {
                print(Error.invalidURL)
                return true
            }
            giphyAPICall(url: giphyTrendingURL) {
                activityIndicator.removeFromSuperview()
                self.notFoundLabel.removeFromSuperview()
                textField.resignFirstResponder()
            }
            return true
        }
        guard let searchURL = giphySearchURL(for: textField.text!) else {
            print(Error.invalidURL)
            return true
        }

        giphyAPICall(url: searchURL) {
            activityIndicator.removeFromSuperview()
            if self.giphyArray.count == 0 {
                self.trendingTableView.separatorStyle = .none
                self.notFoundLabel = UILabel(frame: CGRect(x: self.view.frame.width / 3, y: self.view.frame.height / 2, width: self.view.frame.width / 3, height: 75))
                
                self.view.addSubview(self.notFoundLabel)
                
                self.notFoundLabel.text = "Gifs Not Found. Search Again"
                self.notFoundLabel.textColor = .black
                self.notFoundLabel.adjustsFontSizeToFitWidth = true
                self.view.bringSubviewToFront(self.notFoundLabel)
            }
            else {
                self.notFoundLabel.removeFromSuperview()
                print("Found \(self.giphyArray.count) matching \(String(describing: textField.text))")
            }
            
        }
            textField.resignFirstResponder()
            return true
        }
    
    func didFavoriteButtonPressed(gif: Gif, cell: GiphyTrendingCell) {
        guard let indexPath = trendingTableView.indexPath(for: cell) else {
            return
        }
        var isFavorite = giphyArray[indexPath.row].isFavorite

        isFavorite = !isFavorite
        giphyArray[indexPath.row].isFavorite = isFavorite
        
        if isFavorite {
            cell.favoriteButton.setImage(UIImage(named: "heartFilled"), for: .normal)
            self.gifCoreData.saveGifInFileSystem(gif)
        } else {

            self.gifCoreData.deleteGif(gifID: gif.gifID)
            cell.favoriteButton.setImage(UIImage(named: "heart"), for: .normal)
        }
        
        
        
    }
}

// MARK: - Giphy API calls
extension TrendingViewController {
    
    func giphyTrendingURL() -> URL? {
         guard let url = URL(string: "\(baseURLString)/trending?api_key=\(giphyApiKey)") else {
             print(Error.invalidURL)
             return nil
         }
         return url
     }
     
     func giphySearchURL(for searchTerm:String) -> URL? {
            guard let escapedTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else {
                print(Error.generic)
                return nil
            }
           
        guard let url = URL(string: "\(baseURLString)/search?api_key=\(giphyApiKey)&q=\(escapedTerm)&limit=25&offset=0&rating=G&lang=en") else {
            print(Error.invalidURL)
            return nil
        }
        return url
    }
     
    func giphyAPICall(url: URL, completion: @escaping () -> Void) {
         
         var dataArray = [Gif]()
         URLSession.shared.dataTask(with: url as URL) {(data, response, error) in
             if let error = error {
                 DispatchQueue.main.async {
                        print(error)
                    }
                 return
             }
             do {
                 guard let data = data else {
                     DispatchQueue.main.async {
                        print(Error.noData)
                     }
                    return
                 }
                     
                 let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
                     let trendingData = jsonObject["data"] as! [Dictionary<String , Any>]
                 
                     for gifObject in trendingData {
                         let id = gifObject["id"] as! String
                         let imageData = gifObject["images"] as! [String : Dictionary<String , String>]

                         let imageOriginal = imageData["original"]!
                         let originalUrl = imageOriginal["url"]!
                        
                         
                         let imageFixedHeight = imageData["fixed_height_downsampled"]!
                         let fixedHeightUrl = imageFixedHeight["url"]!
                         
                         let imagedFixedHeightSmall = imageData["fixed_height_small"]!
                         let fixedHeightSmallUrl = imagedFixedHeightSmall["url"]!
                         
                         
                         let gif = Gif(originalUrl: URL(string: originalUrl), fixedHeightUrl: URL(string: fixedHeightUrl), fixedHeightSmallUrl: URL(string: fixedHeightSmallUrl), gifID: id)
                        
                         dataArray.append(gif)
                     }
                     
                     DispatchQueue.main.async {
                         self.giphyArray = dataArray
                         self.trendingTableView.reloadData()
                        completion()
                     }
                 }
             catch {
                 print(error)
             }
         }.resume()
     }
}

// MARK: - Segues
extension TrendingViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFullScreen" {
            let fullScreen = segue.destination as! GifFullScreenViewController
            fullScreen.gif = (sender as! GiphyTrendingCell).gif
        }
        if segue.identifier == "ShowFavorites" {
            let favoritesGrid = segue.destination as! FavoritesViewController
            favoritesGrid.gifCoreData = self.gifCoreData
            
        }
    }
    
}
