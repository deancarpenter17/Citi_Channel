//
//  ChooseTagsViewController.swift
//  InternProject
//
//  Created by Dean Carpenter on 6/30/18.
//  Copyright © 2018 Dean Carpenter. All rights reserved.
//

import UIKit

class ChooseTagsViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var tagCollectionView: UICollectionView!
    
    @IBOutlet weak var beachBackground: UIImageView!
    
    var tags = [Tag]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        //self.navigationItem.title = "Welcome \(FirebaseAPI.shared.currentUser?.displayName ?? "")"
        tagCollectionView.dataSource = self
        
        tags.append(contentsOf: [Tag(name: "Java"), Tag(name: "Angular"), Tag(name: "IT SUPPORT"), Tag(name: "Android"), Tag(name: "Swift"), Tag(name: "Test"), Tag(name: "Test"), Tag(name: "Test"), Tag(name: "Test"), Tag(name: "Test"), Tag(name: "Test"), Tag(name: "Test"), Tag(name: "Test"), Tag(name: "Test"), Tag(name: "Test"), Tag(name: "Test"), Tag(name: "Test"), Tag(name: "Test"), Tag(name: "Test"), Tag(name: "Test"), Tag(name: "Test"), Tag(name: "Test"), Tag(name: "Test"), Tag(name: "Test"), Tag(name: "Test"), Tag(name: "Test")])
        setupCollectionViewLayout()
        blurBackground()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "TagCollectionViewCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! TagCollectionViewCell
        cell.tagName.text = tags[indexPath.row].name
        return cell
    }
    
    func setupCollectionViewLayout() {
        
        //Define Layout here
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        //Get device width
        let width = UIScreen.main.bounds.width
        
        //set section inset as per your requirement.
        layout.sectionInset = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 7)
        
        //set cell item size here
        layout.itemSize = CGSize(width: (width/3)-6, height: (width/3)-6)
        
        //set Minimum spacing between 2 items
        layout.minimumInteritemSpacing = 2
        
        //set minimum vertical line spacing here between two lines in collectionview
        layout.minimumLineSpacing = 2
        
        //apply defined layout to collectionview
        tagCollectionView!.collectionViewLayout = layout
    }
    
    func blurBackground() {
        self.beachBackground.image = UIImage(named: "cartoon_beach")
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = self.beachBackground.bounds
        blurredEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.beachBackground.addSubview(blurredEffectView)
        
    }
}
