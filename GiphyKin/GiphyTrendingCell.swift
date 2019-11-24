//
//  GiphyTrendingCell.swift
//  GiphyKin
//
//  Created by Kamal Maged on 2019-11-24.
//  Copyright © 2019 Kamal Maged. All rights reserved.
//

import UIKit
import ImageIO

class GiphyTrendingCell: UITableViewCell {
    
    @IBOutlet weak var giphyImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var favoriteButton: UIButton!
    var gif = Gif()
    var giphyGif = UIImage() {
        didSet {
            activityIndicator.stopAnimating()
            activityIndicator.alpha = 0
            giphyImage.image = giphyGif
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .black
        configureImage()
//        self.observe("\(self.giphyGif.image)", options: [.initial, .new]) { (self, change) in
//            self.giphyImage.image = self.giphyGif as! UIImage
//        }
//
//        addObserver(self, forKeyPath: "self.giphyGif", options:[.initial , .new], context: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
//    override class func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if keyPath == "self.giphyGif" {
//                self.giphyImage.image = self.giphyGif
//        }
//    }
    func configureImage() {
        activityIndicator.alpha = 1
        activityIndicator.startAnimating()
        guard let url = gif.fixedHeightUrl else {
            return
        }

        let task = URLSession.shared.dataTask(with: url as URL) { (data, response, error) in
            do {
                if data != nil {
                DispatchQueue.main.async {
                    if let image = UIImage.gif(data: data!){
                        self.giphyGif = image
                        } else { return }
                    }
                }
            }

        }
        task.resume()
    }
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        favoriteButton.imageView?.image = UIImage(named: "favoriteIconSelected")

    }
}
