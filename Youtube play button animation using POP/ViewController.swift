//
//  ViewController.swift
//  Youtube play button animation using POP
//
//  Created by xiaolei on 16/5/17.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var playButton: PlayButton!
    
    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playButton = PlayButton()
        playButton.frame = CGRect(x: floor((view.bounds.width - 150.0) / 2.0), y: 50.0, width: 150.0, height: 150.0)
        playButton.addTarget(self, action: #selector(ViewController.playButtonPressed), forControlEvents: .TouchUpInside)
        view.addSubview(playButton)
    }
    
    // MARK: -
    // MARK: Methods
    
    func playButtonPressed() {
        if playButton.buttonState == .Playing {
            playButton.setButtonState(.Paused, animated: true)
        } else {
            playButton.setButtonState(.Playing, animated: true)
        }
    }


}

