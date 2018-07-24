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
    @IBOutlet weak var postTitleLbl: UILabel!
    @IBOutlet weak var postAuthorLbl: UILabel!
    @IBOutlet weak var postDescriptionText: UITextView!
    
    @IBOutlet weak var solutionTableView: UITableView!
    
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
            FirebaseAPI.shared.readSolutions(postUID: postUID) { newSolutions in
                DispatchQueue.main.async {
                    self.solutions = newSolutions
                    self.solutionTableView.reloadData()
                }
            }
        } else {
            print("Error! Unable to get postUID on DetailedPostViewController!")
        }
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let solutionCell = tableView.dequeueReusableCell(withIdentifier: "answerCell", for: indexPath) as! DetailedPostTableViewCell
        solutionCell.answerDescriptionText.text = solutions[indexPath.row].solution
        solutionCell.answerTitleLbl.text = solutions[indexPath.row].username
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
        } else {
            print("Error! Can't get post UID!!")
        }
        return solutionCell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateSolutionSegue" {
            if let createSolutionVC = segue.destination as? CreateSolutionPopupViewController {
                createSolutionVC.postUID = postUID
            }
        }
    }
    
    fileprivate func setupViews() {
        // Do any additional setup after loading the view.
        
        postTitleLbl.text! = postTitle
        postAuthorLbl.text! = postAuthor
        postDescriptionText.text! = postDescrip
        
        //Make nav title the title of the post selected
        self.navigationItem.title = postTitle
        
        //Makes nav back button white to go with color scheme
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        //Remove side scroll on solution tableview
        solutionTableView.showsVerticalScrollIndicator = false
    }
}















