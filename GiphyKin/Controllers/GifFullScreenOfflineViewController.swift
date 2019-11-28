//
//  GifFullScreenOfflineViewController.swift
//  GiphyKin
//
//  Created by Kamal Maged on 2019-11-28.
//  Copyright © 2019 Kamal Maged. All rights reserved.
//

import UIKit

class GifFullScreenOfflineViewController: UIViewController {

    
    @IBOutlet weak var fullScreen: UIImageView!
    var gifOriginalData: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fullScreen.image =  UIImage.gif(data: gifOriginalData!)
        // Do any additional setup after loading the view.
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
