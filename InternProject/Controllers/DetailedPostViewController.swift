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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let solutionCell = tableView.dequeueReusableCell(withIdentifier: "answerCell", for: indexPath)

        
        
        return solutionCell
    }
}
