//
//  CreatePostPopupViewController.swift
//  InternProject
//
//  Created by Jaylin Phipps on 7/7/18.
//  Copyright © 2018 Dean Carpenter. All rights reserved.
//

import Foundation
import UIKit
import SearchTextField

class CreatePostPopupViewController: UIViewController {
    
    @IBOutlet weak var userPostTitle: UITextField!
    @IBOutlet weak var userPostDescrip: UITextView!
    @IBOutlet weak var userPostTags: SearchTextField!
    
    var post: Post?
    var tags = [Tag]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseAPI.shared.getTags() { (tags) in
            self.tags = tags
            self.userPostTags.theme.bgColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 0.98)
            self.userPostTags.theme.borderColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
            self.userPostTags.theme.separatorColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 0.98)
            // Need to convert [Tag] to [String] for this filterStrings method
            var tagsStringArray = [String]()
            for tag in self.tags {
                tagsStringArray.append(tag.name)
            }
            self.userPostTags.filterStrings(tagsStringArray)
        }
        
    }
    
    func textFieldsEmpty() -> Bool {
        if userPostTitle.text == "" || userPostDescrip.text == "" || userPostTags.text == "" {
            let alert = UIAlertController(title: "Error Creating Post!", message: "Please fill in all fields.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            return true
        } else {
            return false
        }
    }
    
    @IBAction func submitBtnClicked(_ sender: Any) {
        if !textFieldsEmpty() {
            if let user = FirebaseAPI.shared.currentUser {
                let uid = UUID().uuidString
                post = Post(ownerUID: user.uid, ownerName: user.displayName!, description: userPostDescrip.text, tags: [Tag(name: userPostTags.text!)], title: userPostTitle.text!, postUID: uid, postDate: Date())
                FirebaseAPI.shared.save(post: post!)
                
                // Once they click submit, let's pop back to the HomeViewController
                self.performSegueToReturnBack()
            } else {
                print("Error posting! No user is signed in!")
            }
        }
    }
    
    @IBAction func closeBtnClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
