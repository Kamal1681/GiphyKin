//
//  Gif.swift
//  GiphyKin
//
//  Created by Kamal Maged on 2019-11-25.
//  Copyright © 2019 Kamal Maged. All rights reserved.
//

import Foundation

struct Gif {
    var originalUrl : URL?
    var fixedHeightUrl : URL?
    var fixedHeightSmallUrl : URL?
    var gifID : String = ""
    var isFavorite = false

}

enum Error : Swift.Error {
    case invalidURL
    case noData
    case unknownAPIResponse
    case invalidGif
    case generic
}


