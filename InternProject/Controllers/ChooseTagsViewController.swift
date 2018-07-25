//
//  ChooseTagsViewController.swift
//  InternProject
//
//  Created by Dean Carpenter on 6/30/18.
//  Copyright © 2018 Dean Carpenter. All rights reserved.
//

import UIKit
import SearchTextField

class ChooseTagsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var saveTagsButton: RoundedLoginButton!
    
    var tags = [Tag]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tagCollectionView.dataSource = self
        tagCollectionView.delegate = self
        
        FirebaseAPI.shared.getTags() { (tags) in
            DispatchQueue.main.async {
                self.tags = tags
                self.tagCollectionView.reloadData()
            }
        }
        setupCollectionViewLayout()
    }
    
    @IBAction func saveTagsPressed(_ sender: RoundedLoginButton) {
        if let indexPaths = tagCollectionView.indexPathsForSelectedItems {
            let tagsCount = indexPaths.count
            print(tagsCount)
            var selectedTags: [Tag] = []
            if tagsCount == 0 {
                // TODO: Create alert for this
                print("you must select at least 1 tag!")
            } else {
                for indexPath in indexPaths {
                    selectedTags.append(tags[indexPath.row])
                }
            }
            FirebaseAPI.shared.save(tags: selectedTags)
            let homeTabController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeTabController")
            FirebaseAPI.shared.appDelegate.navigateTo(viewController: homeTabController)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "TagCollectionViewCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! TagCollectionViewCell
        cell.tagName.text = tags[indexPath.row].name
        cell.layer.cornerRadius = 5
        cell.layer.masksToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        print("selected")
        let cell = collectionView.cellForItem(at: indexPath)
        
        if let state = cell?.isSelected {
            if state {
                return false
            }
        }
        cell?.layer.borderWidth = 2.0
        cell?.layer.borderColor = UIColor.black.cgColor
        // Citi red color
        //cell?.layer.backgroundColor = UIColor(red: 219.0/255, green: 35.0/255, blue: 11.0/255, alpha: 0.95).cgColor
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        let cell = collectionView.cellForItem(at: indexPath)
        if let state = cell?.isSelected {
            if !state {
                return false
            }
        }
        cell?.layer.borderWidth = 0.0
        cell?.layer.borderColor = UIColor.clear.cgColor
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.saveTagsButton.isHidden = shouldHideSaveButton()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        self.saveTagsButton.isHidden = shouldHideSaveButton()
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
        tagCollectionView.allowsMultipleSelection = true
        
        self.saveTagsButton.isHidden = shouldHideSaveButton()
        
    }
    
    // If at least one tag is selected, show the save bar button item
    func shouldHideSaveButton() -> Bool {
        return self.tagCollectionView.indexPathsForSelectedItems?.count == 0
    }
}











