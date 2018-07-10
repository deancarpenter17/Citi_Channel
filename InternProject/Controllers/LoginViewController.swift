//
//  LoginViewController.swift
//  InternProject
//
//  Created by Dean Carpenter on 7/9/18.
//  Copyright © 2018 Dean Carpenter. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    @IBAction func googleLoginButtonPressed(_ sender: GIDSignInButton) {
        FirebaseAPI.shared.signInWithGoogle(shouldSignInSilently: false)
    }
}
