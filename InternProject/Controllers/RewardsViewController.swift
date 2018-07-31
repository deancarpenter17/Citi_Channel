//
//  RewardsViewController.swift
//  InternProject
//
//  Created by Jaylin Phipps on 7/9/18.
//  Copyright © 2018 Dean Carpenter. All rights reserved.
//

import UIKit

class RewardsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var rewardsCollectionView: UICollectionView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var rewardsTableView: UITableView!
    
    var users = [UserNF]()
    
    var rewardImages = [#imageLiteral(resourceName: "targetLogo"),#imageLiteral(resourceName: "citiLogo"),#imageLiteral(resourceName: "Bitmap"),#imageLiteral(resourceName: "bestbuyLogo"),#imageLiteral(resourceName: "starbucksLogo")]
    var rewardDescriptions = ["Target $25 Gift Card", "VIP Parking Space","2019 Ferrari 488 Spider", "Best Buy $25 Gift Card", "Starbucks $15 Gift Card"]
    var rewardPoints = ["150 Points", "300 Points","10,000 Points", "150 Points", "100 Points"]
 
    override func viewWillAppear(_ animated: Bool) {
        // Get the total score and all the users for the leaderboard
        if let currentUser = FirebaseAPI.shared.currentUser {
            FirebaseAPI.shared.getUserStatistics(userUID: currentUser.uid) { [weak self] (totalScore, _, _) in
                DispatchQueue.main.async {
                    self?.scoreLabel.text = totalScore.description
                }
            }
            
            FirebaseAPI.shared.getUsers() { [weak self] (users) in
                DispatchQueue.main.async {
                    self?.users = users.sorted(by: { (user1, user2) -> Bool in
                        return user1.totalScore > user2.totalScore
                    })
                    self?.rewardsTableView.reloadData()
                }
            }
        }
        //removes scroll bar
        rewardsCollectionView.showsHorizontalScrollIndicator = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //sets nav title to rewards
        self.navigationItem.title = "Rewards"
        
        rewardsTableView.tableFooterView = UIView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - CollectionView functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //dumby variable making sure it works
        return rewardImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let rewardCell = collectionView.dequeueReusableCell(withReuseIdentifier: "rewardCell", for: indexPath) as! RewardsCollectionViewCell
        
        rewardCell.rewardImg.image = rewardImages[indexPath.row]
        rewardCell.rewardTitleLbl.text = rewardDescriptions[indexPath.row]
        rewardCell.rewardPointsLbl.text = rewardPoints[indexPath.row]
        
        
        return rewardCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //If user wants the reward we have to check if they have enough points if they do then get that reward.
    }
    
    
    // MARK: - TableView Functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //dumby variable making sure it works
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let leaderboardCell = tableView.dequeueReusableCell(withIdentifier: "leaderboardCell", for: indexPath) as! LeaderboardTableViewCell
        leaderboardCell.rankPointsLbl.text = users[indexPath.row].totalScore.description
        leaderboardCell.rankNameLbl.text = users[indexPath.row].username
        leaderboardCell.rankingLbl.text = (indexPath.row + 1).description
        
        return leaderboardCell
    }
    
    
    @IBAction func signOut(_ sender: UIBarButtonItem) {
        FirebaseAPI.shared.signoutUser()
    }
}
