//
//  RewardsViewController.swift
//  InternProject
//
//  Created by Jaylin Phipps on 7/9/18.
//  Copyright © 2018 Dean Carpenter. All rights reserved.
//

import UIKit

class RewardsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //sets nav title to rewards
        self.navigationItem.title = "Rewards"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //START OF COLLECTION VIEW
    //NEEDED COLLECTION VIEW FUNCTIONS
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //dumby variable making sure it works
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let rewardCell = collectionView.dequeueReusableCell(withReuseIdentifier: "rewardCell", for: indexPath) as! RewardsCollectionViewCell
        
        return rewardCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    //END OF COLLECTION VIEW
    
    //START OF TABLE VIEW
    //NEEDED TABLE VIEW FUNCTION
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //dumby variable making sure it works
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let leaderboardCell = tableView.dequeueReusableCell(withIdentifier: "leaderboardCell", for: indexPath)
        
        return leaderboardCell
    }
    //END OF TABLE VIEW
    
    
    @IBAction func signOut(_ sender: UIBarButtonItem) {
        FirebaseAPI.shared.signoutUser()
    }
}
