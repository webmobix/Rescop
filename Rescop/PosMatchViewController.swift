//
//  PosMatchViewController.swift
//  Rescop
//
//  Created by Danny Thüring on 26.05.18.
//  Copyright © 2018 Webmobix. All rights reserved.
//

import Foundation
import UIKit

class PosMatchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet var tableView: UITableView?
  var images: [ImageData] = []
  
  override func viewWillAppear(_ animated: Bool) {
    images = DataStore.sharedInstance.images.filter({ (image) -> Bool in
      return image.match
    })
    print("viewWillAppear")
    tableView?.reloadData()
  }

  override func viewDidLoad() {
    images = DataStore.sharedInstance.images.filter({ (image) -> Bool in
      return image.match
    })
    print(images)
    
//    tableView?.register(ImageViewCell.self, forCellReuseIdentifier: "ImageCell")
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    print("numberOfRowsInSection: \(images.count)")
    return images.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ImageViewCell

    let imageData = images[indexPath.row]

    cell.locationImageView?.image = imageData.image!
    cell.locationLabel?.text = String(format: "%.4f, %.4f", (imageData.coordinate?.latitude)!, (imageData.coordinate?.longitude)!)
    cell.classificationLabel?.text = imageData.classification

    return cell
  }
  
  
  
  
}
