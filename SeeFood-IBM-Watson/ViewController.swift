//
//  ViewController.swift
//  SeeFood-IBM-Watson
//
//  Created by Aivaras Gustys on 21/06/2019.
//  Copyright © 2019 Aivaras Gustys. All rights reserved.
//

import UIKit
import VisualRecognition
import SVProgressHUD
import Social

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let apiKEY = "aBK3bmXh2OI8wgtJBVFY491ZGVes-AVfNL7ZII3cwe95"
    let version = "2019-06-22"

    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topBarImage: UIImageView!
    
    let imagePicker = UIImagePickerController()
    var classificationResults : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        cameraButton.isEnabled = false
        SVProgressHUD.show()
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            imagePicker.dismiss(animated: true, completion: nil)
            
            let visualRecognition = VisualRecognition(version: version, apiKey: apiKEY)
            
            visualRecognition.classify(image: image) { (classifiedImages, error) in
        
                if let classes = classifiedImages?.result?.images.first!.classifiers.first!.classes {
                
                    print("we are in")
                    self.classificationResults = []
                    
                    for index in 0 ..< classes.count {
                        self.classificationResults.append(classes[index].className)
                    }
                    
                    DispatchQueue.main.async {
                        self.cameraButton.isEnabled = true
                        SVProgressHUD.dismiss()
                    }
                    
                    if self.classificationResults.contains("hotdog") {
                        DispatchQueue.main.async {
                            self.navigationItem.title = "Hotdog!"
                            self.topBarImage.image = UIImage(named: "hotdog")
                            self.navigationController?.navigationBar.barTintColor = UIColor.green
                            self.navigationController?.navigationBar.isTranslucent = false
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            self.navigationItem.title = "Not Hotdog!"
                            self.topBarImage.image = UIImage(named: "not-hotdog")
                            self.navigationController?.navigationBar.barTintColor = UIColor.red
                            self.navigationController?.navigationBar.isTranslucent = false
                        }
                    }
                }
                else {
                    print("error classifying image")
                }
                
                print(self.classificationResults)
            }
        }
        else {
            print("There was an error picking the image")
        }
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: nil)
        
    }
}

