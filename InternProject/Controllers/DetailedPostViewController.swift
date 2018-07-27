//
//  DetailedPostViewController.swift
//  InternProject
//
//  Created by Jaylin Phipps on 7/7/18.
//  Copyright © 2018 Dean Carpenter. All rights reserved.
//

import Foundation
import UIKit

class DetailedPostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var solutionTblView: UITableView!
    
    var postTitle = ""
    var postAuthor = ""
    var postDescrip = ""
    var postUID: String?
    
    var solutions = [Solution]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        // Set the listener on the solutions for this particular post
        if let postUID = postUID {
            FirebaseAPI.shared.getSolutions(postUID: postUID) { newSolutions in
                DispatchQueue.main.async {
                    self.solutions = newSolutions
                    self.solutionTblView.reloadData()
                }
            }
        } else {
            print("Error! Unable to get postUID on DetailedPostViewController!")
        }
        
        self.solutionTblView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
        
        solutionTblView.estimatedSectionHeaderHeight = 100
        solutionTblView.sectionHeaderHeight = UITableViewAutomaticDimension
        
        solutionTblView.estimatedRowHeight = 100
        solutionTblView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return solutions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let solutionCell = tableView.dequeueReusableCell(withIdentifier: "answerCell", for: indexPath) as! DetailedPostTableViewCell
        solutionCell.answerDescriptionLbl.text = solutions[indexPath.row].solution

        solutionCell.answerNameLbl.text = solutions[indexPath.row].username
        solutionCell.score = solutions[indexPath.row].score
        solutionCell.ownerUID = solutions[indexPath.row].ownerUID
        if let postUID = postUID {
            solutionCell.postUID = postUID
            FirebaseAPI.shared.getUserVoteHistory(postUID: postUID, ownerUID: solutions[indexPath.row].ownerUID) { (score) in
                DispatchQueue.main.async {
                    solutionCell.userVoteHistory = score
                    print("Users vote history: \(score)")
                }
            }
            FirebaseAPI.shared.getSolutionReplies(postUID: postUID, solutionUID: solutions[indexPath.row].ownerUID) { (replies) in
                DispatchQueue.main.async {
                    let replyString = replies.count == 1 ? "Reply ➡︎" : "Replies ➡︎"
                    solutionCell.repliesLbl.setTitle("\(replies.count.description) \(replyString)", for: .normal)
                }
            }
        } else {
            print("Error! Can't get post UID!!")
        }
        return solutionCell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cellIdentifier = "sectionHeader"
        let sectionHeaderCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? sectionHeaderView
        
        sectionHeaderCell?.titleLabel.text = postTitle
        sectionHeaderCell?.descriptionLbl.text = postDescrip
        sectionHeaderCell?.authorLbl.text = "By: \(postAuthor)"
        return sectionHeaderCell?.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateSolutionSegue" {
            if let createSolutionVC = segue.destination as? CreateSolutionPopupViewController {
                createSolutionVC.postUID = postUID
            }
        }
        
        if segue.identifier == "SolutionReplySegue" {
            if let sender = sender as? UIButton {
                if let solutionReplyVC = segue.destination as? SolutionReplyViewController {
                    guard let cell = sender.superview?.superview as? DetailedPostTableViewCell else {
                        print("Error! DetailedPostViewController:prepareForSegue.  Cannot cast sender to DetailedPostTableViewCell!")
                        return // or fatalError() or whatever
                    }
                    
                    if let indexPath = self.solutionTblView.indexPath(for: cell), let postUID = postUID {
                        solutionReplyVC.solutionUID = self.solutions[indexPath.row].ownerUID
                        solutionReplyVC.postUID = postUID
                    }
                }
            }
        }
    }
    
    fileprivate func setupViews() {
        // Do any additional setup after loading the view.
        

        
        //Make nav title the title of the post selected
        self.navigationItem.title = "Post"
        
        //Makes nav back button white to go with color scheme
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        //Remove side scroll on solution tableview
        solutionTblView.showsVerticalScrollIndicator = false
        
        solutionTblView.tableFooterView = UIView()
    }

}














