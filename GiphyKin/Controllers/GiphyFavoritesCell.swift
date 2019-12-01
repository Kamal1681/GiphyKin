//
//  GiphyFavoritesCell.swift
//  GiphyKin
//
//  Created by Kamal Maged on 2019-11-27.
//  Copyright © 2019 Kamal Maged. All rights reserved.
//

import UIKit

protocol RemoveFromFavorites {
    func didFavoriteButtonPressed(gifID: String, cell: GiphyFavoritesCell)
}
class GiphyFavoritesCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var favoriteButton: UIButton!
    var gif = Gif()
    var gifOriginalData: Data?
    var gifID: String = ""
  
    var delegate: RemoveFromFavorites?
    
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        delegate?.didFavoriteButtonPressed(gifID: gifID, cell: self)
    }

}

