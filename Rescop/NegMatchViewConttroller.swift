//
//  NegMatchViewConttroller.swift
//  Rescop
//
//  Created by Danny Thüring on 26.05.18.
//  Copyright © 2018 Webmobix. All rights reserved.
//

import Foundation
import UIKit

class NegMatchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  var images: [ImageData] = []
  @IBOutlet var tableView: UITableView?

  override func viewWillAppear(_ animated: Bool) {
    images = DataStore.sharedInstance.images.filter({ (image) -> Bool in
      return !image.match
    })
    print("viewWillAppear")
    tableView?.reloadData()
  }
  
  override func viewDidLoad() {
    images = DataStore.sharedInstance.images.filter({ (image) -> Bool in
      return image.match
    })
    print(images)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    print("numberOfRowsInSection: \(images.count)")
    return images.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    print("cellForRowAt: \(indexPath)")
    //    var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    //    if cell == nil {
    var cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
    //    }
    
    let imageData = images[indexPath.row]
    
    cell.imageView?.image = imageData.image!
    cell.textLabel?.text = imageData.classification
    
    return cell
  }
  
}
