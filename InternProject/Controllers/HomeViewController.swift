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
    
    // nil here tells the search controller that you want use the same view you’re searching to display the results.
    let searchController = UISearchController(searchResultsController: nil)
    
    var posts = [Post]()
    var filteredPosts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FirebaseAPI.shared.getPosts() { [weak self] newPosts in
            DispatchQueue.main.async {
                self?.posts = newPosts
                self?.tableView.reloadData()
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
        if isFiltering() {
            return filteredPosts.count
        }
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        if let cell = cell as? PostTableViewCell {
            
            let post: Post
            if isFiltering() {
                post = filteredPosts[indexPath.row]
            } else {
                post = posts[indexPath.row]
            }
            
            cell.postTitleLbl.text = post.title
            var tagString = ""
            for tag in post.tags {
                tagString += " \(tag.name)"
            }
            cell.tagLbl.text = tagString
            cell.descriptionLbl.text = post.description
            cell.nameLbl.text = "By: \(post.ownerName)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let descriptionVC = mainStoryBoard.instantiateViewController(withIdentifier: "DetailedPostViewController") as! DetailedPostViewController
        
        if isFiltering() {
            descriptionVC.post = filteredPosts[indexPath.row]
        } else {
            descriptionVC.post = posts[indexPath.row]
        }
        
        self.navigationController?.pushViewController(descriptionVC, animated: true)
    }
    
    // MARK: - Search
    
    @IBAction func searchButtonItemPressed(_ sender: UIBarButtonItem) {
        searchController.isActive = true
    }
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        
        AlgoliaAPI.shared.searchPosts(for: searchText) { [weak self] (posts) in
            print(posts)
            self?.filteredPosts = posts
        }
        
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    // MARK: - View Setup
    func setupViews() {
        // Do any additional setup after loading the view.
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.navigationItem.title = "Home"
        tableView.tableFooterView = UIView()
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Posts"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        searchController.searchBar.setImage(UIImage(named: "my_search_icon"), for: UISearchBarIcon.search, state: .normal)
        searchController.searchBar.setImage(UIImage(named: "my_search_icon"), for: UISearchBarIcon.clear, state: .normal)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.black]
        
        let scb = searchController.searchBar
        scb.tintColor = UIColor.lightGray
        scb.barTintColor = UIColor.white
        searchController.searchBar.tintColor = .white
        
        if let textfield = scb.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor.black
            if let backgroundview = textfield.subviews.first {
                
                // Background color
                backgroundview.backgroundColor = UIColor.white
                
                // Rounded corner
                backgroundview.layer.cornerRadius = 10;
                backgroundview.clipsToBounds = true;
            }
        }
        // Changes the cursor color of the search bar
        searchController.searchBar.subviews[0].subviews.flatMap(){ $0 as? UITextField }.first?.tintColor = UIColor.black
        // this line fixes an iOS bug where a white line appears in the search controller animation
        navigationController?.navigationBar.isTranslucent = false
    }
}

extension HomeViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
