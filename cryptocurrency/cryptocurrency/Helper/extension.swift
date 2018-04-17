//
//  extension.swift
//  cryptocurrency
//
//  Created by Khoa Nguyen on 4/2/18.
//  Copyright © 2018 KhoaNguyen. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()
extension UIImageView {
    func loadImageUsingCacheWithUrlString(urlString:String) {
        
        self.image = nil
        
        //check cache for image first
        if let cacheImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage{
            self.image = cacheImage
            return
        }
        
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil{
                print(error!)
                return
            }
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!){
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self.image = downloadedImage
                }else{
                    //print("LOI: \(urlString.split(separator: "/")[6])")
                }
                
                
            }
        }).resume()
        
    }
}
extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}

extension Float {
    func toString() -> String {
        let num = 6 - String(Int(self)).count
        let format = "%." + String(num) + "f"
        return String(format: format, self)
    }
}
extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}
