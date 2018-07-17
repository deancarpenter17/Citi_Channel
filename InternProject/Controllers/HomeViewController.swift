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
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FirebaseAPI.shared.readPosts() { newPosts in
            DispatchQueue.main.async {
                self.posts = newPosts
                self.tableView.reloadData()
            }
        }
        
        setupViews()
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
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        if let cell = cell as? PostTableViewCell {
            let thePost = posts[indexPath.row]
            cell.postTitleLbl.text = thePost.title
        }
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let descriptionVC = mainStoryBoard.instantiateViewController(withIdentifier: "DetailedPostViewController") as! DetailedPostViewController
        
        descriptionVC.postTitle = posts[indexPath.row].title
        descriptionVC.postAuthor = posts[indexPath.row].ownerUID
        descriptionVC.postDescrip = posts[indexPath.row].description
    
        self.navigationController?.pushViewController(descriptionVC, animated: true)
    }
    
    func setupViews() {
        // Do any additional setup after loading the view.
        tableView.separatorColor = UIColor(white: 1, alpha: 1)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.navigationItem.title = "Home"
    }

}
