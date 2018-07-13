//
//  LoginViewController.swift
//  InternProject
//
//  Created by Dean Carpenter on 7/9/18.
//  Copyright © 2018 Dean Carpenter. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Login"
    }
    
    @IBAction func loginButtonPressed(_ sender: RoundedLoginButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            FirebaseAPI.shared.loginUser(email: email, password: password) { hasError, errorDescription in
                if hasError {
                    AlertController.showAlert(self, title: "Error", message: errorDescription)
                }
            }
        } else {
            AlertController.showAlert(self, title: "Missing info", message: "You must fill out all fields!")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 'First Responder' is the same as 'input focus'.
        // We are removing input focus from the text field.
        textField.resignFirstResponder()
        return true
    }
    
    // Called when the user touches on the main view (outside the UITextField).
    //
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
