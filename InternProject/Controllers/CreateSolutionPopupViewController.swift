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
    
    var postUID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func closeSolutionPage(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func answerDescripEmpty() -> Bool {
        if solutionDescriptionTextField.text == "" {
            let alert = UIAlertController(title: "Error Posting Solution!", message: "Please fill in all fields.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            return true
        } else {
            return false
        }
    }
    
    @IBAction func solutionSubmitClicked(_ sender: Any) {
        if !answerDescripEmpty(), let postUID = postUID, let user = FirebaseAPI.shared.currentUser {
            FirebaseAPI.shared.save(solution: solutionDescriptionTextField.text, postUID: postUID, userUID: user.uid, username: user.displayName!)
            self.performSegueToReturnBack()
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
