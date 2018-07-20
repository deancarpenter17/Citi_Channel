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
        if let user = currentUser {
            self.ref.child("users/\(user.uid)/tags").setValue(tagsToStringsArray(tagArray: tags))
        }
    }
    
    // Saves a user's post
    func save(post: Post) {
        let postDict: [String: Any] = [
            "ownerUID": post.ownerUID,
            "ownerName": post.ownerName,
            "postDescription": post.description,
            "postTags": tagsToStringsArray(tagArray: post.tags),
            "postTitle": post.title,
        ]
        self.ref.child("posts/\(post.postUID)").setValue(postDict)
    }
    
    // Saves a solution to a user's post
    func save(solution: String, postUID: String, userUID: String, username: String) {
        let initialRating = 1
        let solutionDict: [String : Any] = [
            "solution": solution,
            "ownerName": username,
            "ownerUID": userUID,
            "rating": initialRating
        ]
        
        self.ref.child("posts/\(postUID)/solutions/\(userUID)").setValue(solutionDict)
    }
    
    func readPosts(completion: @escaping ([Post]) -> Void) {
        self.ref.child("posts").observe(DataEventType.value, with: { (snapshot) in
            let postsDict = snapshot.value as? [String : AnyObject] ?? [:]
            var posts = [Post]()
            // Convert postsDict to [Post]
            for postsDictKey in postsDict {
                let postUID = postsDictKey.key as String
                let ownerName = postsDict[postsDictKey.key]!["ownerName"] as? String ?? ""
                let ownerUID = postsDict[postsDictKey.key]!["ownerUID"] as? String ?? ""
                let postDescription = postsDict[postsDictKey.key]!["postDescription"] as? String ?? ""
                let postTagsStrings = postsDict[postsDictKey.key]!["postTags"] as? [String] ?? []
                // Convert [String] to [Post]
                var postTags = [Tag]()
                for tag in postTagsStrings {
                    postTags.append(Tag(name: tag))
                }
                let postTitle = postsDict[postsDictKey.key]!["postTitle"] as? String ?? ""
                let post = Post(ownerUID: ownerUID, ownerName: ownerName, description: postDescription, tags: postTags, title: postTitle, postUID: postUID)
                posts.append(post)
            }
            print(posts)
            completion(posts)
        })
    }
    
    func readSolutions(postUID: String, completion: @escaping ([Solution]) -> Void) {
        self.ref.child("posts/\(postUID)/solutions").observe(DataEventType.value, with: { (snapshot) in
            let solutionsDict = snapshot.value as? [String : AnyObject] ?? [:]
            print(solutionsDict)
            var solutions = [Solution]()
            // Convert solutionsDict to [Solution]
            for solutionsDictKey in solutionsDict {
                let ownerName = solutionsDict[solutionsDictKey.key]!["ownerName"] as? String ?? ""
                let ownerUID = solutionsDict[solutionsDictKey.key]!["ownerUID"] as? String ?? ""
                let solutionText = solutionsDict[solutionsDictKey.key]!["solution"] as? String ?? ""
                let rating = solutionsDict[solutionsDictKey.key]!["rating"] as? Int ?? 1
                
                let solution = Solution(solution: solutionText, username: ownerName, ownerUID: ownerUID, rating: rating)
                print("Solution: \(solution.solution)")
                solutions.append(solution)
            }
            print(solutions)
            completion(solutions)
        })
    }
    
    func readTags(completion: @escaping ([Tag]) -> Void) {
        self.ref.child("tags").observe(DataEventType.value, with: { (snapshot) in
            let tagsStringArray = snapshot.value as? [String] ?? []
            var tagsArray = [Tag]()
            for stringTag in tagsStringArray {
                tagsArray.append(Tag(name: stringTag))
            }
            completion(tagsArray)
        })
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
    
    // MARK: - Helper functions
    
    func tagsToStringsArray(tagArray: [Tag]) -> [String] {
        var tags = [String]()
        for tag in tagArray {
            tags.append(tag.name)
        }
        return tags
    }
    
}
