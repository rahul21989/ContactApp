//
//  ImagePicker.swift
//  ContactApp
//
//  Created by Rahul Goyal on 21/06/19.
//  Copyright © 2019 RG. All rights reserved.
//

import UIKit
import Photos

enum AlertType : Int {
    case noAblum, noCamera
}

class ImagePicker: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    typealias ImagePickerCompletion = (_ image:UIImage?, _ error:Error? ) -> Void
    
    static let shared = ImagePicker()
    var completionBlock:ImagePickerCompletion?
    static var VC:UIViewController?
    
    class func showActionSheet(_ viewController:UIViewController, _ completion:@escaping ImagePickerCompletion) {
        
        //Static function which we need outside
        VC = viewController
        ImagePicker.shared.completionBlock = completion
        
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
                if authStatus == .authorized {
                    openImagePicker(1)
                } else if authStatus == .denied || authStatus == .restricted {
                    showAlert(forSetting: .noCamera)
                } else if authStatus == .notDetermined {
                    AVCaptureDevice.requestAccess(for: .video, completionHandler: {(_ granted: Bool) -> Void in
                        if granted {
                            openImagePicker(1)
                        } else {
                            showAlert(forSetting: .noCamera)
                        }
                    })
                }
            } else {
                let alert = UIAlertController(title: "", message: "Camera not available in device.", preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
                alert.addAction(okayAction)
                VC?.present(alert, animated: true)
            }
        })
        
        let choosePhoto = UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let authStatus = PHPhotoLibrary.authorizationStatus()
                if authStatus == .authorized {
                    openImagePicker(0)
                } else if authStatus == .denied || authStatus == .restricted {
                    showAlert(forSetting: .noAblum)
                } else if authStatus == .notDetermined {
                    PHPhotoLibrary.requestAuthorization({ status in
                        if status == .authorized {
                            openImagePicker(0)
                        } else {
                            showAlert(forSetting: .noAblum)
                        }
                    })
                }
            } else {
                
                let alert = UIAlertController(title: "", message: "Photo Library not available in device.", preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
                alert.addAction(okayAction)
                VC?.present(alert, animated: true)
            }
        })
        
        let cancelPhoto = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let alertController = UIAlertController(title: nil, message:nil, preferredStyle: .actionSheet)
        
        alertController.addAction(takePhoto)
        alertController.addAction(choosePhoto)
        alertController.addAction(cancelPhoto)
        
        alertController.modalPresentationStyle = .popover
        
        let popup = alertController.popoverPresentationController
        popup?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        popup?.sourceView = VC?.view
        popup?.sourceRect = CGRect(x: (VC?.view.bounds.midX)!, y: (VC?.view.bounds.midY)!, width: 0, height: 0)
        
        VC?.present(alertController, animated: true, completion: nil)
    }
    
    class func openImagePicker(_ option: UInt) {
        let picker = UIImagePickerController()
        picker.delegate = ImagePicker.shared
        picker.sourceType = UIImagePickerControllerSourceType(rawValue: UIImagePickerControllerSourceType.RawValue(option))!
        picker.allowsEditing = true
        VC?.present(picker,animated: true,completion: nil)
    }
    
    class func showAlert(forSetting type: AlertType) {
        var title = ""
        var message = ""
        if type == .noAblum {
            title = "Photo Library Unavailable"
            message = "Please check to see if device settings doesn't allow photo library access"
        } else if type == .noCamera {
            title = "Camera Unavailable"
            message = "Please check to see if device settings doesn't allow camera access"
        }
        
        let okayAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        let settingAction = UIAlertAction(title: "Settings", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)
            if UIApplication.shared.canOpenURL(settingsUrl!) {
                UIApplication.shared.openURL(settingsUrl!)
            }
        })
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(okayAction)
        alert.addAction(settingAction)
        VC?.present(alert, animated: true)
        
        ImagePicker.shared.completionBlock!(nil, NSError(1234, "Image Pick Not Success"))
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImage:UIImage? = nil
        if (picker.sourceType.rawValue == 0) {
            if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
                selectedImage = editedImage
            } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
                selectedImage = originalImage
            }
        } else if (picker.sourceType.rawValue == 1) {
            if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
                selectedImage = editedImage
            } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
                selectedImage = originalImage
            }
        }
        
        ImagePicker.VC?.dismiss(animated: false, completion: {
            ImagePicker.shared.completionBlock!(selectedImage, nil)
        })
    }
}
