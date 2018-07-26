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
    @IBOutlet weak var repliesTableView: UITableView!
    
    var postUID: String!
    var solutionUID: String!
    var replies = [Reply]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        repliesTableView.estimatedRowHeight = 100
        repliesTableView.rowHeight = UITableViewAutomaticDimension
        FirebaseAPI.shared.getSolutionReplies(postUID: postUID, solutionUID: solutionUID) { (replies) in
            DispatchQueue.main.async {
                self.replies = replies
                self.repliesTableView.reloadData()
            }
        }
        repliesTableView.tableFooterView = UIView()
    }
    
    @IBAction func closeBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func replyButtonPressed(_ sender: UIButton) {
        if let replyText = replyTextField.text, !replyText.isEmpty {
            FirebaseAPI.shared.save(reply: replyText, postUID: postUID, solutionUID: solutionUID)
            self.performSegueToReturnBack()
        }
    }
    
    // MARK: - TableView lifecycle functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //dumby variable making sure it works
        return replies.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let replyCell = tableView.dequeueReusableCell(withIdentifier: "replyCell", for: indexPath)
        if let replyCell = replyCell as? SolutionReplyCell {
            replyCell.usernameLbl.text = replies[indexPath.row].username
            replyCell.replyDescripLbl.text = replies[indexPath.row].replyText
        }
        
        return replyCell
    }
}
