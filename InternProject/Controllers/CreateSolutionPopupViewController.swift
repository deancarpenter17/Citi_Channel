//
//  CreateSolutionPopupViewController.swift
//  InternProject
//
//  Created by Jaylin Phipps on 7/10/18.
//  Copyright © 2018 Dean Carpenter. All rights reserved.
//

import Foundation
import UIKit

class CreateSolutionPopupViewController: UIViewController {
    
    @IBOutlet weak var solutionDescriptionTextField: UITextView!
    
    var tabBarHome: UITabBarItem = UITabBarItem()
    var tabBarRewards: UITabBarItem = UITabBarItem()
    var tabBarProfile: UITabBarItem = UITabBarItem()
    
    @IBAction func closeSolutionPage(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
