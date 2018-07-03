//
//  SplashScreenViewController.swift
//  InternProject
//
//  Created by Dean Carpenter on 6/27/18.
//  Copyright © 2018 Dean Carpenter. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class SplashScreenViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func googleSigninButtonPressed(_ sender: Any) {
        FirebaseAPI.shared.signInWithGoogle(shouldSignInSilently: false)
    }
    
    
    
}
