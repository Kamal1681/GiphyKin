//
//  GiphyTrendingCell.swift
//  GiphyKin
//
//  Created by Kamal Maged on 2019-11-24.
//  Copyright © 2019 Kamal Maged. All rights reserved.
//

import UIKit

protocol FavoriteButtonHandle {
    func didFavoriteButtonPressed(gif: Gif, cell: GiphyTrendingCell)
}

class GiphyTrendingCell: UITableViewCell {
    
    @IBOutlet weak var giphyImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var favoriteButton: UIButton!
    var gif = Gif()
    var favoriteButtonFlag = false
    var delegate: FavoriteButtonHandle?
    
    
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
        favoriteButton.setImage(UIImage(named: "heart"), for: .normal)
    }
    func configureImage() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()

        guard let url = gif.fixedHeightUrl else {
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
                        
                        self.giphyImage.image = image
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true
                        
                        } else { return }
                    }
            }.resume()
        }
        
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        delegate?.didFavoriteButtonPressed(gif: gif, cell: self)
    
    }

}
