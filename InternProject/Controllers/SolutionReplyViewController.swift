//
//  SolutionReplyViewController.swift
//  InternProject
//
//  Created by Jaylin Phipps on 7/24/18.
//  Copyright © 2018 Dean Carpenter. All rights reserved.
//

import UIKit

class SolutionReplyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var replyTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func closeBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func replyButtonPressed(_ sender: UIButton) {
        if let replyText = replyTextField.text, !replyText.isEmpty {
            
        }
    }
    
    // MARK: - TableView lifecycle functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //dumby variable making sure it works
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let replyCell = tableView.dequeueReusableCell(withIdentifier: "replyCell", for: indexPath)
        
        return replyCell
    }
}
