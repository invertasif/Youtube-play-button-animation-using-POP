//
//  PlayButton.swift
//  Youtube play button animation using POP
//
//  Created by xiaolei on 16/5/17.
//  Copyright © 2016年 xiaolei. All rights reserved.
//

import UIKit

enum PlayButtonState {
    case Paused
    case Playing
    
    var value: CGFloat {
        return (self == .Paused) ? 1.0 : 0.0
    }
}

class PlayButton: UIButton {

}
