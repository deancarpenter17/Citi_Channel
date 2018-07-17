//
//  FirebaseAPI.swift
//  InternProject
//
//  Created by Dean Carpenter on 6/29/18.
//  Copyright © 2018 Dean Carpenter. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class FirebaseAPI: NSObject {
    
    var ref: DatabaseReference!
    var appDelegate: AppDelegate!
    static let shared = FirebaseAPI()
    
    var currentUser: User? {
        get {
            return Auth.auth().currentUser
        }
    }
    
    private override init() {
        super.init()
    }
    
    // MARK: - Firebase Initialization
    
    func setupFirebase() {
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        
        // Set the FirebaseAPI database reference
        FirebaseAPI.shared.ref = Database.database().reference()
    }
    
    // MARK: Firebase Authentication

    func signoutUser() {
        try? Auth.auth().signOut()
        print("User signed out")
        let splashNavVC: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SplashNavVC") as UIViewController
        self.appDelegate.navigateTo(viewController: splashNavVC)
    }
    
    func signupUser(username: String, password: String, email: String, completion: @escaping (Bool, String) -> Void) {
    
        self.checkUserNameAlreadyExist(newUserName: username) { isExist in
            if isExist {
                completion(false, "Username already exists! Try again.")
            }
            else {
                Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                    guard error == nil else {
                        completion(true, error?.localizedDescription ?? "Could not create user")
                        return
                    }
    
                    guard user != nil else { return }
    
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = username
                    changeRequest?.commitChanges(completion: {( error ) in
                        guard error == nil else {
                            completion(true, error?.localizedDescription ?? "error in commit changes!")
                            return
                        }
    
                        if let user = self.currentUser {
                            let userToSave = [
                                "name": username,
                                "email": email,
                                "uid": user.uid
                            ]
                            // Save to Firebase.
                            self.ref.child("users/\(user.uid)").setValue(userToSave)
                            
                            print("user successfully logged in!")
                            // Once we're done saving the new user, go to the Tag screen
                            DispatchQueue.main.async {
                                let rootController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TagNavController")
                                self.appDelegate.navigateTo(viewController: rootController)
                            }
                        } else {
                            completion(true, error?.localizedDescription ?? "Error retrieving current user!")
                        }
    
                    })
                })
            }
        }
    }
    
    func loginUser(email: String, password: String, completion: @escaping (Bool, String) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            guard error == nil else {
                print("error logging in!")
                completion(true, error?.localizedDescription ?? "Error logging in!")
                return
            }
            
            // Since they've logged in successfully, jump to home screen
            if let username = self.currentUser?.displayName, let email = self.currentUser?.email {
                print("Current User: " + username + ", Email: " + email)
                DispatchQueue.main.async {
                    let homeTabController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeTabController")
                    self.appDelegate.navigateTo(viewController: homeTabController)
                }
            }
        }
    }
    
    // MARK: - Firebase Database Operations
    
    // Sets the user's tags
    func save(tags: [Tag]) {
        // Convert Tag array into a valid JSON object (arrays are not valid)
        var tagsDict = [String: String]()
        for tag in tags {
            tagsDict[tag.name] = tag.name
        }
        if let user = currentUser {
            self.ref.child("users/\(user.uid)/tags").setValue(tagsDict)
        }
    }
    
    // Saves a user's post
    func save(post: Post) {
        var tagsArrayToString: [String] {
            get {
                var tags = [String]()
                for tag in post.tags {
                    tags.append(tag.name)
                }
                return tags
            }
        }
        
        let postDict: [String: Any] = [
            "owner": post.owner,
            "postDescription": post.description,
            "postTags": tagsArrayToString,
            "postTitle": post.title,
        ]
        self.ref.child("posts/\(post.uid)").setValue(postDict)
    }
    
    // THIS FUNCTION IS ONLY USED TO LOAD DEFAULT TAGS INITIALLY IN FIREBASE
    func tempSave(tags: [Tag]) {
        // Convert Tag array into a valid JSON object (arrays are not valid)
        var tagsDict = [String: String]()
        for tag in tags {
            tagsDict[tag.name] = tag.name
        }
        self.ref.child("tags").setValue(tagsDict)
    }
    
    func checkUserNameAlreadyExist(newUserName: String, completion: @escaping(Bool) -> Void) {
        let ref = Database.database().reference()
        ref.child("users").queryOrdered(byChild: "username").queryEqual(toValue: newUserName)
            .observeSingleEvent(of: .value, with: {(snapshot: DataSnapshot) in
                if snapshot.exists() {
                    completion(true)
                }
                else {
                    completion(false)
                }
            })
    }
    
}
