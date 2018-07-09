//
//  HomeViewController.swift
//  InternProject
//
//  Created by Dean Carpenter on 7/3/18.
//  Copyright © 2018 Dean Carpenter. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
     let post = ["First Post", "Second Post", "Third Post", "Fourth Post","Fifth Post","Sixth Post","Seventh Post","Eighth Post"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.separatorColor = UIColor(white: 1, alpha: 1)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        addNavImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.showsVerticalScrollIndicator = false
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return post.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        if let cell = cell as? PostTableViewCell {
            let thePost = post[indexPath.row]
            cell.postTitleLbl.text = thePost
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let descriptionVC = mainStoryBoard.instantiateViewController(withIdentifier: "DetailedPostViewController") as! DetailedPostViewController
        
        descriptionVC.postTitle = post[indexPath.row]
        descriptionVC.postAuthor = post[indexPath.row]
        descriptionVC.postDescrip = post[indexPath.row]
        
        self.navigationController?.pushViewController(descriptionVC, animated: true)
    }

}
