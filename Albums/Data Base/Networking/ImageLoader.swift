//
//  ImageLoader.swift
//  Albums
//
//  Created by Artem on 8/3/22.
//

import Foundation
import UIKit

final class ImageLoader {
    
    private let cache: NSCache<NSString, UIImage> = NSCache()
    
    var placeholderImage: UIImage? {
        return UIImage(named: "placeholder")
    }
    
    func loadImage(url: URL, completionHandler: @escaping (UIImage?) -> ()) {
        
        let path = url.path as NSString
        
        if let image = self.cache.object(forKey: path) {
            
            completionHandler(image)
            
        } else {
            
            URLSession.shared.dataTask(with: url,
                                       completionHandler: { [weak self] (data, response, error) -> Void in
                
                DispatchQueue.main.async {
                    
                    if let data = data, let image = UIImage(data: data) {
                        self?.cache.setObject(image, forKey: path)
                        completionHandler(image)
                    } else {
                        completionHandler(self?.placeholderImage)
                    }
                }
                
            }).resume()
        }
    }
}
