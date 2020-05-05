//
//  ActivityIndicator.swift
//  ImageSlideshow
//
//  Created by Woramet Prompen on 2019-07-22.
//  Copyright © 2019 Woramet Prompen. All rights reserved.
//

import UIKit

public protocol ActivityIndicatorView {
    var view: UIView { get }

    func show()

    func hide()
}

public protocol ActivityIndicatorFactory {
    func create() -> ActivityIndicatorView
}

extension UIActivityIndicatorView: ActivityIndicatorView {
    public var view: UIView {
        return self
    }

    public func show() {
        self.startAnimating()
    }

    public func hide() {
        self.stopAnimating()
    }
}

@objcMembers
open class DefaultActivityIndicator: ActivityIndicatorFactory {
    open var style: UIActivityIndicatorView.Style
    open var color: UIColor?

    
    public init(style: UIActivityIndicatorView.Style = .gray, color: UIColor? = nil) {
        self.style = style
        self.color = color
    }

    open func create() -> ActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: style)
        activityIndicator.color = color
        activityIndicator.hidesWhenStopped = true

        return activityIndicator
    }
}
