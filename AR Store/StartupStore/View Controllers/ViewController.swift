//
//  ViewController.swift
//  StartupStore
//
//  Created by Woramet Prompen on 2019-07-22.
//  Copyright © 2019 Woramet Prompen. All rights reserved.
//

import UIKit
//import AVKit


class ViewController: UIViewController {
    
//    var videoPlayer:AVPlayer?
//    var videoPlayerLayer:AVPlayerLayer?

    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        // Set up video in the background
//        setUpVideo()

    }
    
    func setUpElements() {
        
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButton(loginButton)
    }
}
   /* func setUpVideo() {
        
        // name vdo in BG
        let bundlePath = Bundle.main.path(forResource: "vdo", ofType: "mp4")
        
        guard bundlePath != nil else {
            return
        }
        
        // Create a URL from it
        let url = URL(fileURLWithPath: bundlePath!)
        
        // Create the video player item
        let item = AVPlayerItem(url: url)
        
        // Create
        videoPlayer = AVPlayer(playerItem: item)
        
        // Create layer
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer!)
        
        //frame
        videoPlayerLayer?.frame = CGRect(x: -self.view.frame.size.width*1.5, y: 0, width: self.view.frame.size.width*4, height: self.view.frame.size.height)
        
        view.layer.insertSublayer(videoPlayerLayer!, at: 0)
        
        // play Video
        videoPlayer?.playImmediately(atRate: 0.3)
    }
    
    
} */

