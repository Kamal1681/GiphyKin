//
//  GifFullImageViewController.swift
//  GiphyKin
//
//  Created by Kamal Maged on 2019-11-25.
//  Copyright © 2019 Kamal Maged. All rights reserved.
//

import UIKit

class GifFullScreenViewController: UIViewController {
    
    @IBOutlet weak var fullScreen: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var gif = Gif()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureImage()
        // Do any additional setup after loading the view.
    }
    
    func configureImage() {
    activityIndicator.isHidden = false
    activityIndicator.startAnimating()
    guard let url = gif.originalUrl else {
        print(Error.invalidURL)
        return
    }
    URLSession.shared.dataTask(with: url as URL) { (data, response, error) in
        if let error = error {
            DispatchQueue.main.async {
                print(error)
            }
          return
        }
            guard let data = data else {
                DispatchQueue.main.async {
                    print(Error.noData)
                }
                return
            }
            DispatchQueue.main.async {
                if let image = UIImage.gif(data: data){
                    
                    self.fullScreen.image = image
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    } else { return }
                }
        }.resume()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
