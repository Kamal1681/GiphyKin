//
//  TrendingViewController.swift
//  GiphyKin
//
//  Created by Kamal Maged on 2019-11-22.
//  Copyright © 2019 Kamal Maged. All rights reserved.
//

import UIKit

let giphyApiKey = "q0suMTvOXQaaTWUzhHMoy0qCEo0xZmKw"
let baseURLString = "https://api.giphy.com/v1/gifs"

class TrendingViewController: UIViewController {
    
    var giphyArray = [Gif]()
    
    private let trendingReuseIdentifier = "GiphyTrendingCell"
    @IBOutlet weak var trendingTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
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
        
        // Do any additional setup after loading the view.
    }

}

// MARK: - DataSource and Delegates

extension TrendingViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return giphyArray.count
        }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = trendingTableView.dequeueReusableCell(withIdentifier: trendingReuseIdentifier, for: indexPath) as! GiphyTrendingCell
            
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
                let notFoundlabel = UILabel(frame: CGRect(x: self.view.frame.width / 3, y: self.view.frame.height / 2, width: self.view.frame.width / 3, height: 75))
                
                self.view.addSubview(notFoundlabel)
                
                notFoundlabel.text = "Gifs Not Found"
                notFoundlabel.textColor = .black
                notFoundlabel.adjustsFontSizeToFitWidth = true
                self.view.bringSubviewToFront(notFoundlabel)
            }
            print("Found \(self.giphyArray.count) matching \(String(describing: textField.text))")
        }

            textField.resignFirstResponder()
            return true
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
                     let pagination = jsonObject["pagination"] as! [String : Int]
                     let meta = jsonObject["meta"] as! [String : Any]
                 
                     for gifObject in trendingData {
                         let id = gifObject["id"] as! String
                         let imageData = gifObject["images"] as! [String : Dictionary<String , String>]

                         let imageOriginal = imageData["original"]!
                         let originalUrl = imageOriginal["url"]!
                         
                         let imageFixedHeight = imageData["fixed_height_downsampled"]!
                         let fixedHeightUrl = imageFixedHeight["url"]!
                         
                         let gif = Gif(originalUrl: URL(string: originalUrl), fixedHeightUrl: URL(string: fixedHeightUrl), gifID: id)
                        
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
    }
    
}
