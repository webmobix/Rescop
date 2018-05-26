//
//  StartViewController.swift
//  Rescop
//
//  Created by Danny Thüring on 26.05.18.
//  Copyright © 2018 Webmobix. All rights reserved.
//

import Foundation
import UIKit
import CoreML
import Vision
import PhotosUI

class StartViewController: UIViewController {
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var classificationLabel: UILabel!
  
  override func viewDidLoad() {
    classificationLabel.text = ""
    
    let photos = PHPhotoLibrary.authorizationStatus()
    if photos == .notDetermined {
      PHPhotoLibrary.requestAuthorization({status in
        if status == .authorized{
          print("authorized")
        } else {
          print("not authorized")
        }
      })
    }
  }
  
  func gotoMap() {

  }
  
  
  // MARK: - Image Classification
  
  /// - Tag: MLModelSetup
  lazy var classificationRequest: VNCoreMLRequest = {
    do {
      let model = try VNCoreMLModel(for: Rescop_986748137().model)
      
      let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
        self?.processClassifications(for: request, error: error)
      })
      request.imageCropAndScaleOption = .centerCrop
      return request
    } catch {
      fatalError("Failed to load Vision ML model: \(error)")
    }
  }()
  
  /// - Tag: PerformRequests
  func updateClassifications(for image: UIImage) {
    print("updateClassifications")
    classificationLabel.text = "Classifying..."
    
    let orientation = CGImagePropertyOrientation(rawValue: UInt32(image.imageOrientation.rawValue))
    guard let ciImage = CIImage(image: image) else { fatalError("Unable to create \(CIImage.self) from \(image).") }
    
    DispatchQueue.global(qos: .userInitiated).async {
      let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation!)
      do {
        try handler.perform([self.classificationRequest])
      } catch {
        /*
         This handler catches general image processing errors. The `classificationRequest`'s
         completion handler `processClassifications(_:error:)` catches errors specific
         to processing that request.
         */
        print("Failed to perform classification.\n\(error.localizedDescription)")
      }
    }
  }
  
  /// Updates the UI with the results of the classification.
  /// - Tag: ProcessClassifications
  func processClassifications(for request: VNRequest, error: Error?) {
    DispatchQueue.main.async {
      guard let results = request.results else {
        self.classificationLabel.text = "Unable to classify image.\n\(error!.localizedDescription)"
        return
      }
      // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
      let classifications = results as! [VNClassificationObservation]
      
      if classifications.isEmpty {
        self.classificationLabel.text = "Nothing recognized."
        print("Nothing recognized")
      } else {
        // Display top classifications ranked by confidence in the UI.
        let topClassifications = classifications.prefix(2)
        let descriptions = topClassifications.map { classification in
          // Formats the classification for display; e.g. "(0.37) cliff, drop, drop-off".
          return String(format: "  (%.2f) %@", classification.confidence, classification.identifier)
        }
        print(descriptions)
        self.classificationLabel.text = "Classification:\n" + descriptions.joined(separator: "\n")
        
        let top = topClassifications.first
        // let match = top!.confidence > 0.9 ? true : false
        let match = top!.identifier == "roofpeople"
        DataStore.sharedInstance.addImage(image: self.imageView.image!, classification: String(format: "(%.2f) %@", top!.confidence, top!.identifier), match: match)
      }
    }
  }
  
  // MARK: - Photo Actions
  
  @IBAction func takePicture() {
    // Show options for the source picker only if the camera is available.
    guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
      presentPhotoPicker(sourceType: .photoLibrary)
      return
    }
    
    let photoSourcePicker = UIAlertController()
    let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { [unowned self] _ in
      self.presentPhotoPicker(sourceType: .camera)
    }
    let choosePhoto = UIAlertAction(title: "Choose Photo", style: .default) { [unowned self] _ in
      self.presentPhotoPicker(sourceType: .photoLibrary)
    }
    
    photoSourcePicker.addAction(takePhoto)
    photoSourcePicker.addAction(choosePhoto)
    photoSourcePicker.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
    present(photoSourcePicker, animated: true)
  }
  
  func presentPhotoPicker(sourceType: UIImagePickerControllerSourceType) {
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.sourceType = sourceType
    present(picker, animated: true)
  }
  
}

extension StartViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  // MARK: - Handling Image Picker Selection
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
    picker.dismiss(animated: true)
    
//     We always expect `imagePickerController(:didFinishPickingMediaWithInfo:)` to supply the original image.
     let image = info[UIImagePickerControllerOriginalImage] as! UIImage
    imageView.image = image
    updateClassifications(for: image)
  }
}

