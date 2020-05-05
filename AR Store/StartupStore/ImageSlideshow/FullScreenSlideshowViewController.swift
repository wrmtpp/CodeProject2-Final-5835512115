//
//  FullScreenSlideshowViewController.swift
//  ImageSlideshow
//
//  Created by Woramet Prompen on 2019-07-22.
//  Copyright © 2019 Woramet Prompen. All rights reserved.
//

import UIKit

@objcMembers
open class FullScreenSlideshowViewController: UIViewController {

    open var slideshow: ImageSlideshow = {
        let slideshow = ImageSlideshow()
        slideshow.zoomEnabled = true
        slideshow.contentScaleMode = UIView.ContentMode.scaleAspectFit
        slideshow.pageControlPosition = PageControlPosition.insideScrollView

        slideshow.slideshowInterval = 0
        slideshow.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]

        return slideshow
    }()

    open var closeButton = UIButton()

    open var closeButtonFrame: CGRect?

    open var pageSelected: ((_ page: Int) -> Void)?

    open var initialPage: Int = 0

    open var inputs: [InputSource]?

    open var backgroundColor = UIColor.black

    open var zoomEnabled = true {
        didSet {
            slideshow.zoomEnabled = zoomEnabled
        }
    }

    fileprivate var isInit = true

    override open func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = backgroundColor
        slideshow.backgroundColor = backgroundColor

        if let inputs = inputs {
            slideshow.setImageInputs(inputs)
        }

        view.addSubview(slideshow)

        closeButton.setImage(UIImage(named: "Frameworks/ImageSlideshow.framework/ImageSlideshow.bundle/ic_cross_white@2x"), for: UIControl.State())
        closeButton.addTarget(self, action: #selector(FullScreenSlideshowViewController.close), for: UIControl.Event.touchUpInside)
        view.addSubview(closeButton)
    }

    override open var prefersStatusBarHidden: Bool {
        return true
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if isInit {
            isInit = false
            slideshow.setCurrentPage(initialPage, animated: false)
        }
    }

    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        slideshow.slideshowItems.forEach { $0.cancelPendingLoad() }
    }

    open override func viewDidLayoutSubviews() {
        if !isBeingDismissed {
            let safeAreaInsets: UIEdgeInsets
            if #available(iOS 11.0, *) {
                safeAreaInsets = view.safeAreaInsets
            } else {
                safeAreaInsets = UIEdgeInsets.zero
            }
            
            closeButton.frame = closeButtonFrame ?? CGRect(x: max(10, safeAreaInsets.left), y: max(10, safeAreaInsets.top), width: 20, height: 20)
        }

        slideshow.frame = view.frame
    }

    @objc func close() {
        if let pageSelected = pageSelected {
            pageSelected(slideshow.currentPage)
        }

        dismiss(animated: true, completion: nil)
    }
}
