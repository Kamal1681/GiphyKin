//
//  GiphySearchResult.swift
//  GiphyKin
//
//  Created by Kamal Maged on 2019-11-25.
//  Copyright © 2019 Kamal Maged. All rights reserved.
//

import Foundation

enum GiphyResult<ResultType> {
  case results(ResultType)
  case error(Error)
}
struct GiphySearchResult {
    let searchTerm : String
    var searchResults : [Gif]
}
