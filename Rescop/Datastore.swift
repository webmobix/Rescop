//
//  Datastore.swift
//  Rescop
//
//  Created by Danny Thüring on 26.05.18.
//  Copyright © 2018 Webmobix. All rights reserved.
//

import Foundation
import UIKit
import MapKit

struct ImageData {
  var image: UIImage? = nil
  var classification: String = ""
  var match: Bool = false
  var coordinate: CLLocationCoordinate2D? = nil
}

class DataStore {
  static let sharedInstance = DataStore()

  public var images: [ImageData] = []

  func addImage(image: UIImage, classification: String, match: Bool) {
    let d1 = drand48() - 0.5
    let d2 = drand48() - 0.5

    let c = CLLocationCoordinate2D(latitude: (22.7487411 + d1), longitude: (90.4508617 + d2))

    images.append(ImageData(image: image, classification: classification, match: match, coordinate: c))
  }
  
}
