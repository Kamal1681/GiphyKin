//
//  FavoritesViewController.swift
//  GiphyKin
//
//  Created by Kamal Maged on 2019-11-25.
//  Copyright © 2019 Kamal Maged. All rights reserved.
//

import UIKit
import CoreData

class FavoritesViewController: UIViewController {
    
    private let favoritesReuseIdentifier = "GiphyFavoriteCell"
    private let spacing: CGFloat = 10
    @IBOutlet weak var favoritesCollectionView: UICollectionView!
    var gifCoreData : GifCoreDataInterface?
    
    var gif = Gif()
    var gifDataArray = [GifData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        favoritesCollectionView.dataSource = self
        favoritesCollectionView.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.favoritesCollectionView.collectionViewLayout = layout
        
        loadSavedData()
        // Do any additional setup after loading the view.
    }
    
    func loadSavedData() {
        let request : NSFetchRequest<GifData> = GifData.fetchRequest()
        let sort = NSSortDescriptor(key: "gifID", ascending: true)
        request.sortDescriptors = [sort]
        
        do {
            gifDataArray = try GifCoreDataInterface.container.viewContext.fetch(request)
            print("Got \(gifDataArray.count) commits")
    
        } catch {
            print("Fetch failed")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - DataSource and Delegates

extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gifDataArray.count
    }
    
 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = favoritesCollectionView.dequeueReusableCell(withReuseIdentifier: favoritesReuseIdentifier, for: indexPath) as! GiphyFavoritesCell
        let imageData = gifDataArray[indexPath.row].fixedHeightSmallData
        cell.image.image = UIImage.gif(data: imageData)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           let numberOfItemsPerRow:CGFloat = 2
           let spacingBetweenCells:CGFloat = 16
           
           let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
           
           if let collection = favoritesCollectionView {
               let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
               return CGSize(width: width, height: width)
           }else{
               return CGSize(width: 0, height: 0)
           }
       }
    
       func collectionView(_ collectionView: UICollectionView,
                           layout collectionViewLayout: UICollectionViewLayout,
                           insetForSectionAt section: Int) -> UIEdgeInsets {
           return UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
       }
    
        func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
           return UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing).left
    }
}

// MARK: - Segues

extension FavoritesViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowFullScreen" {
            let fullScreen = segue.destination as! GifFullScreenViewController
            fullScreen.gif = (sender as! GiphyFavoritesCell).gif
        }
    }
}
