//
//  CustomExtensions.swift
//  ArchitecturalDemo
//
//  Created by Rakesh Gujari on 03/03/18.
//  Copyright © 2018 Rakesh Gujari. All rights reserved.
//

import UIKit

/// image

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    func loadImage(_ urlString : String, tag: Int? = nil) {
        let url = URL(string: urlString)
        let tagValue = tag == nil ? "" : "\(tag!)"
        self.image = nil
        if(url == nil) {
            return
        }
        
        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString+tagValue as NSString) as? UIImage {
            self.image = cachedImage
            return
        }
        
        // if not, download image from url
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString+tagValue as NSString)
                    self.image = image
                }
            }
            
        }).resume()
    }
}
