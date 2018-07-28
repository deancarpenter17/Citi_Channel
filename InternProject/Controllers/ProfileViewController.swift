//
//  ProfileViewController.swift
//  InternProject
//
//  Created by Dean Carpenter on 7/7/18.
//  Copyright © 2018 Dean Carpenter. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var pointsLbl: UILabel!
    @IBOutlet weak var numPostsLbl: UILabel!
    @IBOutlet weak var numSolutionsLbl: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // We want to update the user's statistics on the Profile Page everytime they come back to this screen
        if let currentUser = FirebaseAPI.shared.currentUser {
            nameLbl.text = currentUser.displayName
            FirebaseAPI.shared.getUserStatistics(userUID: currentUser.uid) { [weak self] (totalPoints, totalNumPosts, totalNumSolutions) in
                DispatchQueue.main.async {
                    self?.numPostsLbl.text = totalNumPosts.description
                    self?.numSolutionsLbl.text = totalNumSolutions.description
                    self?.pointsLbl.text = totalPoints.description
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Sets nav title
        self.navigationItem.title = "Profile"
    }
    
    @IBAction func signOut(_ sender: UIBarButtonItem) {
        FirebaseAPI.shared.signoutUser()
    }
    
    @IBAction func myTagsBtnClicked(_ sender: Any) {
        let rootController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TagNavController")
        self.present(rootController, animated: true, completion: nil)
    }
}
