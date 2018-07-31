//
//  FilterViewController.swift
//  InternProject
//
//  Created by Jaylin Phipps on 7/26/18.
//  Copyright © 2018 Dean Carpenter. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var filterTableView: UITableView!
    
    let sorts = ["Newest","Oldest","Popular"]
    var posts: [Post]?
    
    var lastSelection: NSIndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let footview = UIView()
        footview.backgroundColor = UIColor.clear
        filterTableView.tableFooterView = footview
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sorts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sortCell = tableView.dequeueReusableCell(withIdentifier: "sortingOptionCell", for: indexPath) as! SortingOptionsCell
        sortCell.sortingLbl.text = sorts[indexPath.row]
        
        return sortCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.lastSelection != nil {
            self.filterTableView.cellForRow(at: self.lastSelection as IndexPath)?.accessoryType = .none
        }
        
        self.filterTableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        self.lastSelection = indexPath as NSIndexPath
        
        self.filterTableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func saveFilterBtn(_ sender: Any) {
        let filteredPosts = filter(by: self.lastSelection.row)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshTableViewWithFilteredPosts"), object: nil, userInfo: ["filteredPosts": filteredPosts])
        self.dismiss(animated: true, completion: nil)
    }
    
    func filter(by index: Int) -> [Post]? {
        if let posts = self.posts {
            switch sorts[index] {
            case "Newest":
                return posts.sorted() { (post1, post2) in
                    return post1.postDate > post2.postDate
                }
            case "Oldest":
                return posts.sorted() { (post1, post2) in
                    return post1.postDate < post2.postDate
                }
            case "Popular":
                return posts.sorted() { (post1, post2) in
                    return post1.popularity > post2.popularity
                }
            default:
                return posts
            }
        } else {
            return self.posts
        }
    }
    
    
}
