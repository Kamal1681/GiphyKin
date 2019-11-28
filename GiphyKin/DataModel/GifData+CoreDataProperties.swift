//
//  GifData+CoreDataProperties.swift
//  GiphyKin
//
//  Created by Kamal Maged on 2019-11-27.
//  Copyright © 2019 Kamal Maged. All rights reserved.
//
//

import Foundation
import CoreData


extension GifData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GifData> {
        return NSFetchRequest<GifData>(entityName: "GifData")
    }

    @NSManaged public var originalData: Data
    @NSManaged public var fixedHeightSmallData: Data
    @NSManaged public var gifID: String

}
