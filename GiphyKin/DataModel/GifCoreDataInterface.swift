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
    var dataArray = [GifData]()
    
    static var container: NSPersistentContainer {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError("Could not convert delegate to AppDelegate") }
        appDelegate.saveContext()
        return appDelegate.persistentContainer
    }
    
    func saveGifInFileSystem(_ gif: Gif) {
        
        for object in dataArray {
            if object.gifID == gif.gifID {
                return
            }
        }
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
        return
    }
    
    func deleteGif(gifID: String) {
        let context = GifCoreDataInterface.container.viewContext
        dataArray = loadSavedData()
        
        for object in dataArray {

            if object.gifID == gifID {
                context.delete(object)
                do {
                    try context.save()
                }
                catch {
                    print(Error.noData)
                }
            }
        }
            
    }
    
    func deleteRecords() {
    
        let context = GifCoreDataInterface.container.viewContext

        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "GifData")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print (Error.generic)
        }
    }
    
    func loadSavedData() -> [GifData] {
        let request : NSFetchRequest<GifData> = GifData.fetchRequest()
        let sort = NSSortDescriptor(key: "gifID", ascending: true)
        request.sortDescriptors = [sort]
        
        
        do {
            dataArray = try GifCoreDataInterface.container.viewContext.fetch(request)
            print("Got \(dataArray.count) commits")
    
        } catch {
            print("Fetch failed")
        }
        return dataArray
    }

    
    private func insert<T>(_ type: T.Type, into context: NSManagedObjectContext) -> T {
        return NSEntityDescription.insertNewObject(forEntityName: String(describing: T.self), into: context) as! T
        
    }
    
}
