//
//  CreatePostPopupViewController.swift
//  InternProject
//
//  Created by Jaylin Phipps on 7/7/18.
//  Copyright © 2018 Dean Carpenter. All rights reserved.
//

import Foundation
import UIKit

class CreatePostPopupViewController: UIViewController {
    
    @IBOutlet weak var userPostTitle: UITextField!
    @IBOutlet weak var userPostDescrip: UITextView!
    @IBOutlet weak var userPostTags: UITextField!
    
    var postTitles = [String]()
    var postDescriptions = [String]()
    var postTags = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fieldsNotEmpty() {
        if userPostTitle.text == "" || userPostDescrip.text == "" || userPostTags.text == "" {
            let alert = UIAlertController(title: "Error Creating Post!", message: "Please fill in all fields.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        } else {
            postTitles.append(userPostTitle.text!)
            postDescriptions.append(userPostDescrip.text!)
            postTags.append(userPostTags.text!)
            self.dismiss(animated: true, completion: nil)
            print(postTitles[0])
        }
    }
    
    @IBAction func submitBtnClicked(_ sender: Any) {
        fieldsNotEmpty()
    }
    
    @IBAction func closeBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
