//
//  MapViewController.swift
//  Rescop
//
//  Created by Danny Thüring on 26.05.18.
//  Copyright © 2018 Webmobix. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class ImageAnnotation: NSObject, MKAnnotation {
  let title: String?
  let coordinate: CLLocationCoordinate2D
  
  init(_ title: String, _ coordinate: CLLocationCoordinate2D) {
    self.title = title
    self.coordinate = coordinate
    
    super.init()
  }
}

class MapViewController: UIViewController {

  @IBOutlet weak var map: MKMapView!
  
  var markers: [ImageAnnotation] = []
  
  override func viewDidLoad() {
    let initialLocation = CLLocation(latitude: 22.7487411, longitude: 90.4508617)
    centerMapOnLocation(location: initialLocation)
    
//    DataStore.sharedInstance.images.map({ (image) -> ImageAnnotation in
//      return ImageAnnotation(image.classification, image.coordinate!)
//    }).forEach { (image) in
//        map.addAnnotation(image)
//    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    markers.forEach { (marker) in
      map.removeAnnotation(marker)
    }
    
    DataStore.sharedInstance.images.map({ (image) -> ImageAnnotation in
      return ImageAnnotation(image.classification, image.coordinate!)
    }).forEach { (image) in
      map.addAnnotation(image)
      markers.append(image)
    }

  }
  
  let regionRadius: CLLocationDistance = 100000
  func centerMapOnLocation(location: CLLocation) {
    let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                              regionRadius, regionRadius)
    map.setRegion(coordinateRegion, animated: false)
  }
  
}
