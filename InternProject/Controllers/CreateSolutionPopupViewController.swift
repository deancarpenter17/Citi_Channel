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
    
    @IBAction func closeSolutionPage(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func answerDescripNotEmpty() {
        if solutionDescriptionTextField.text == "" {
            let alert = UIAlertController(title: "Error Posting Solution!", message: "Please fill in all fields.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        } else {
            //Store answer description and users name to DB here
        }
    }
    
    @IBAction func solutionSubmitClicked(_ sender: Any) {
        answerDescripNotEmpty()
    }
    
}
