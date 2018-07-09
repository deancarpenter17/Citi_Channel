//
//  ProfileViewController.swift
//  InternProject
//
//  Created by Dean Carpenter on 7/7/18.
//  Copyright © 2018 Dean Carpenter. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        addNavImage()
    }
    
    @IBAction func signOut(_ sender: UIBarButtonItem) {
        FirebaseAPI.shared.signoutUser()
    }
}
