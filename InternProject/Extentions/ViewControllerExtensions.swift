//
//  ViewControllerExtensions.swift
//  InternProject
//
//  Created by Dean Carpenter on 7/13/18.
//  Copyright © 2018 Dean Carpenter. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func performSegueToReturnBack()  {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
