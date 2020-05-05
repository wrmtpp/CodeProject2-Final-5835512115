//
//  InputSource.swift
//  ImageSlideshow
//
//  Created by Woramet Prompen on 2019-07-22.
//  Copyright © 2019 Woramet Prompen. All rights reserved.
//

import UIKit

@objc public protocol InputSource {
    
    func load(to imageView: UIImageView, with callback: @escaping (_ image: UIImage?) -> Void)
    
    @objc optional func cancelLoad(on imageView: UIImageView)
}

@objcMembers
open class ImageSource: NSObject, InputSource {
    var image: UIImage!

    public init(image: UIImage) {
        self.image = image
    }


    public init?(imageString: String) {
        if let image = UIImage(named: imageString) {
            self.image = image
            super.init()
        } else {
            return nil
        }
    }

    public func load(to imageView: UIImageView, with callback: @escaping (UIImage?) -> Void) {
        imageView.image = image
        callback(image)
    }
}
