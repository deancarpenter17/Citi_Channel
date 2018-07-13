//
//  SignupViewController.swift
//  InternProject
//
//  Created by Dean Carpenter on 7/9/18.
//  Copyright © 2018 Dean Carpenter. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Sign up"
    }
    
    @IBAction func signUpButtonPressed(_ sender: RoundedLoginButton) {
        if let username = usernameTextField.text, let password = passwordTextField.text,
            let email = emailTextField.text {
            
            FirebaseAPI.shared.signupUser(username: username, password: password, email: email) { hasError, errorMessage in
                if hasError {
                    AlertController.showAlert(self, title: "Error", message: errorMessage )
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
