//
//  RoundedLoginButton.swift
//  InternProject
//
//  Created by Dean Carpenter on 6/27/18.
//  Copyright © 2018 Dean Carpenter. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class RoundedLoginButton: UIButton
{
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateCornerRadius()
    }
    
    @IBInspectable var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }
    
    func updateCornerRadius() {
        layer.cornerRadius = rounded ? frame.size.height / 2 : 0
    }
}
