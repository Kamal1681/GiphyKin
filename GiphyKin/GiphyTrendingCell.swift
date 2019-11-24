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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .black
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        giphyImage.image = nil
        if !gif.isFavorite {
            favoriteButton.setImage(UIImage(named: "favoriteIcon"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(named: "favoriteIconSelected"), for: .normal)
        }
        
    }
    func configureImage() {
       
        activityIndicator.startAnimating()
        guard let url = gif.fixedHeightUrl else {
            return
        }
        let task = URLSession.shared.dataTask(with: url as URL) { (data, response, error) in
            do {
                if data != nil {
                DispatchQueue.main.async {
                    if let image = UIImage.gif(data: data!){
                        
                        self.giphyImage.image = image
                        self.activityIndicator.stopAnimating()
                        
                        } else { return }
                    }
                }
            }

        }
        task.resume()
    }
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        if !gif.isFavorite {
            gif.isFavorite = true
            favoriteButton.setImage(UIImage(named: "favoriteIcon"), for: .normal)
        } else {
            gif.isFavorite = false
            favoriteButton.setImage(UIImage(named: "favoriteIconSelected"), for: .normal)
        }
    }

}
