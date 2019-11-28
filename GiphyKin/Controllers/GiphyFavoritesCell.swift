//
//  GiphyFavoritesCell.swift
//  GiphyKin
//
//  Created by Kamal Maged on 2019-11-27.
//  Copyright © 2019 Kamal Maged. All rights reserved.
//

import UIKit

class GiphyFavoritesCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    
    var gif = Gif()
    var gifOriginalData: Data?
}

