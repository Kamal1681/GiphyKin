//
//  GifCoreDataInterface.swift
//  GiphyKin
//
//  Created by Kamal Maged on 2019-11-27.
//  Copyright © 2019 Kamal Maged. All rights reserved.
//

import Foundation
import CoreData
import UIKit


// Saves and loads images from CoreData.

class GifCoreDataInterface {
    static var container: NSPersistentContainer {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError("Could not convert delegate to AppDelegate") }
        appDelegate.saveContext()
        return appDelegate.persistentContainer
    }
    
    func saveGifInFileSystem(_ gif: Gif) -> GifData {
        let gifData = insert(GifData.self, into: GifCoreDataInterface.container.viewContext)
        
        gifData.gifID = gif.gifID
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try Data(contentsOf: gif.originalUrl!)
                DispatchQueue.main.async {
                    gifData.originalData = data
                }
            }
            catch {
                print(Error.noData)
            }
        }
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try Data(contentsOf: gif.fixedHeightSmallUrl!)
                DispatchQueue.main.async {
                    gifData.fixedHeightSmallData = data
                }
            }
            catch {
                print(Error.noData)
            }
        }
        
        return gifData
    }
    
    private func insert<T>(_ type: T.Type, into context: NSManagedObjectContext) -> T {
        return NSEntityDescription.insertNewObject(forEntityName: String(describing: T.self), into: context) as! T
        
    }
    
}
