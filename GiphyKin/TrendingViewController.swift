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
    
    var trendingArray = [Gif]()
    var searchArray = [Gif]()
    
    private let trendingReuseIdentifier = "GiphyTrendingCell"
    @IBOutlet weak var trendingTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trendingTableView.delegate = self
        trendingTableView.dataSource = self
        searchTextField.delegate = self
        trendingAPI()
     
        // Do any additional setup after loading the view.
    }

}

// MARK: - DataSource and Delegates

extension TrendingViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trendingArray.count
        }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = trendingTableView.dequeueReusableCell(withIdentifier: trendingReuseIdentifier, for: indexPath) as! GiphyTrendingCell
            
            cell.gif = trendingArray[indexPath.row]
            cell.configureImage()
            return cell
        }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
        
    //    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    //
    //      let activityIndicator = UIActivityIndicatorView(style: .gray)
    //      textField.addSubview(activityIndicator)
    //      activityIndicator.frame = textField.bounds
    //      activityIndicator.startAnimating()
    //
    //      flickr.searchFlickr(for: textField.text!) { searchResults in
    //        activityIndicator.removeFromSuperview()
    //
    //        switch searchResults {
    //        case .error(let error) :
    //          print("Error Searching: \(error)")
    //        case .results(let results):
    //          print("Found \(results.searchResults.count) matching \(results.searchTerm)")
    //          self.searches.insert(results, at: 0)
    //          self.collectionView.reloadData()
    //        }
    //      }
    //
    //      textField.text = nil
    //      textField.resignFirstResponder()
    //      return true
    //    }
        
}

// MARK: - API calls

extension TrendingViewController {
    
    func trendingAPI() {
        guard let url = URL(string: "\(baseURLString)/trending?api_key=\(giphyApiKey)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url as URL) {(data, response, error) in
            do {
                if data != nil {
                    var dataArray = [Gif]()
                    let jsonObject = try JSONSerialization.jsonObject(with: data!, options: []) as! [String : Any]
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
                        self.trendingArray = dataArray
                        self.trendingTableView.reloadData()
                    }
                }
            }
            catch {
                print(error)
            }
            
        }
        task.resume()
    }
}
