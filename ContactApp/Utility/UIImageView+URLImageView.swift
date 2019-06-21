//
//  UIImageView+URLImageView.swift
//  ContactApp
//
//  Created by Rahul Goyal on 21/06/19.
//  Copyright © 2019 RG. All rights reserved.
//


import UIKit
import SDWebImage

private let downloadButtonTag = 525010

extension UIImageView {
    
    // MARK: Private Methods
    func setImageWithURL(_ aImageURLString: String, withCompletionBlock completionBlock: ((_ aImageUrlString: String, _ error: Error?) -> Void)?) {
        
        image = UIImage(named: "placeholder_photo")

        guard let imageUrl = URL(string: aImageURLString), !aImageURLString.isEmpty else {
            if completionBlock != nil {
                completionBlock?(aImageURLString, NSError(404, "aImageURLString can not be converted to NSURL."))
            }
            return
        }
        
        if NetworkManager.shared.isNetworkAvailable {
            sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholder_photo"), options: .retryFailed) { (_, error, _, imageURL) in
                if completionBlock != nil {
                    completionBlock?(imageURL?.absoluteString ?? "", error)
                }
            }
        } else {
            SDWebImageManager.shared().diskImageExists(for: imageUrl) { (isInCache) in
                var callRemoteForImageURLString  = false
                if (isInCache) {
                    callRemoteForImageURLString = true
                } else if !NetworkManager.shared.isNetworkAvailable {
                    callRemoteForImageURLString  = false
                } else {
                    callRemoteForImageURLString = true
                }
                
                if callRemoteForImageURLString {
                    self.sd_setImage(with: imageUrl) { (_, error, _, imageURL) in
                        if completionBlock != nil {
                            completionBlock?(imageURL?.absoluteString ?? "", error)
                        }                        
                    }
                } else {
                    DispatchQueue.main.async(execute: {
                        // -1.0 specific case when we don't want downloading button for Listing page
                        if completionBlock != nil {
                            completionBlock?(aImageURLString, nil)
                        }
                    })
                }
            }
        }
    }
}
