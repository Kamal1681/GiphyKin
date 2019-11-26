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
    var isFavorite = false
    var gifID : String = ""

}

enum Error : Swift.Error {
    case invalidURL
    case noData
    case unknownAPIResponse
    case generic
}


