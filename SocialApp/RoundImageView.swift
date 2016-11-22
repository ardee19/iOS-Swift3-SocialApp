//
//  RoundImageView.swift
//  SocialApp
//
//  Created by Roy Dimayuga on 11/10/16.
//  Copyright © 2016 Super Awesome. All rights reserved.
//

import UIKit

class RoundImageView: UIImageView {
    
    override func layoutSubviews() {
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }
    
}
