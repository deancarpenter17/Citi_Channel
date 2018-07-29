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
    
    // MARK: - Instance variables
    var ref: DatabaseReference!
    var appDelegate: AppDelegate!
    static let shared = FirebaseAPI()
    
    var currentUser: User? {
        get {
            return Auth.auth().currentUser
        }
    }
    
    // MARK: - initialization
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
    
    // MARK: - Firebase Authentication
    
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
                                "username": username,
                                "email": email,
                                "UID": user.uid,
                                "totalScore": 0,
                                "totalNumSolutions": 0,
                                "totalNumPosts": 0
                                ] as [String : Any]
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
    
    // MARK: - Save
    
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
            "popularity": post.popularity,
            "timestamp": ServerValue.timestamp(),
            "postUID": post.postUID
        ]
        self.ref.child("posts/\(post.postUID)").setValue(postDict)
        
        // update the user's score who created the new Post
        updateUsersTotalScore(by: ScoreConstants.PostScore, forUserUID: post.ownerUID)
        
        // update user's total number of posts
        incrementUsersPostCount(forUserUID: post.ownerUID)
    }
    
    // Saves a solution to a user's post
    func save(solution: String, postUID: String, userUID: String, username: String) {
        let solutionDict: [String : Any] = [
            "solution": solution,
            "ownerName": username,
            "ownerUID": userUID,
            "timestamp": ServerValue.timestamp(),
            "score": ScoreConstants.InitialSolutionUpvotes
        ]
        
        self.ref.child("posts/\(postUID)/solutions/\(userUID)").setValue(solutionDict)
        
        // update the user's total score for creating a solution
        updateUsersTotalScore(by: ScoreConstants.SolutionScore, forUserUID: userUID)
        
        // update the user's total number of solutions
        incrementUsersSolutionCount(forUserUID: userUID)
        
        // update the post's popularity
        updatePostPopularity(by: 1, for: postUID)
    }
    
    func save(reply: String, postUID: String, solutionUID: String) {
        if let currentUser = self.currentUser, let username = currentUser.displayName {
            let replyDict = [
                "username": username,
                "userUID": currentUser.uid,
                "replyText": reply,
                "timestamp": ServerValue.timestamp()
                ] as [String : Any]
            self.ref.child("posts/\(postUID)/solutions/\(solutionUID)/replies/\(currentUser.uid)").setValue(replyDict)
        }
        
        // update the post's popularity
        updatePostPopularity(by: 1, for: postUID)
    }
    
    // MARK: - Get
    func getPosts(completion: @escaping ([Post]) -> Void) {
        self.ref.child("posts").observe(DataEventType.value, with: { (snapshot) in
            let postsDict = snapshot.value as? [String : AnyObject] ?? [:]
            var posts = [Post]()
            // Convert postsDict to [Post]
            for postsDictKey in postsDict {
                let postUID = postsDictKey.key as String
                let ownerName = postsDict[postsDictKey.key]?["ownerName"] as? String ?? ""
                let ownerUID = postsDict[postsDictKey.key]?["ownerUID"] as? String ?? ""
                let postDescription = postsDict[postsDictKey.key]?["postDescription"] as? String ?? ""
                let postTagsStrings = postsDict[postsDictKey.key]?["postTags"] as? [String] ?? []
                var postDate = Date()
                if let t = postsDict[postsDictKey.key]?["timestamp"] as? TimeInterval {
                    postDate = Date(timeIntervalSince1970: t/1000)
                }
                // Convert [String] to [Post]
                var postTags = [Tag]()
                for tag in postTagsStrings {
                    postTags.append(Tag(name: tag))
                }
                let postTitle = postsDict[postsDictKey.key]?["postTitle"] as? String ?? ""
                let postPopularity = postsDict[postsDictKey.key]?["popularity"] as? Int ?? 0
                let post = Post(ownerUID: ownerUID, ownerName: ownerName, description: postDescription, tags: postTags, title: postTitle, postUID: postUID, postDate: postDate, popularity: postPopularity)
                posts.append(post)
            }
            completion(posts)
        })
    }
    
    func getSolutions(postUID: String, completion: @escaping ([Solution]) -> Void) {
        self.ref.child("posts/\(postUID)/solutions").observe(DataEventType.value, with: { (snapshot) in
            let solutionsDict = snapshot.value as? [String : AnyObject] ?? [:]
            var solutions = [Solution]()
            // Convert solutionsDict to [Solution]
            for solutionsDictKey in solutionsDict {
                let ownerName = solutionsDict[solutionsDictKey.key]?["ownerName"] as? String ?? ""
                let ownerUID = solutionsDict[solutionsDictKey.key]?["ownerUID"] as? String ?? ""
                let solutionText = solutionsDict[solutionsDictKey.key]?["solution"] as? String ?? ""
                let score = solutionsDict[solutionsDictKey.key]?["score"] as? Int ?? 1
                var solutionDate = Date()
                if let t = solutionsDict[solutionsDictKey.key]?["timestamp"] as? TimeInterval {
                    solutionDate = Date(timeIntervalSince1970: t/1000)
                }
                let solution = Solution(solution: solutionText, username: ownerName, ownerUID: ownerUID, score: score, solutionDate: solutionDate)
                solutions.append(solution)
            }
            completion(solutions)
        })
    }
    
    func getSolutionReplies(postUID: String, solutionUID: String, completion: @escaping ([Reply]) -> Void) {
        self.ref.child("posts/\(postUID)/solutions/\(solutionUID)/replies").observe(DataEventType.value, with: { (snapshot) in
            let responseDict = snapshot.value as? [String: AnyObject] ?? [:]
            var replies = [Reply]()
            for repliesDictKey in responseDict {
                let username = responseDict[repliesDictKey.key]?["username"] as? String ?? ""
                let userUID = responseDict[repliesDictKey.key]?["userUID"] as? String ?? ""
                let replyText = responseDict[repliesDictKey.key]?["replyText"] as? String ?? ""
                var solutionReplyDate = Date()
                if let t = responseDict[repliesDictKey.key]?["timestamp"] as? TimeInterval {
                    solutionReplyDate = Date(timeIntervalSince1970: t/1000)
                }
                let reply = Reply(username: username, userUID: userUID, replyText: replyText, replyDate: solutionReplyDate)
                replies.append(reply)
            }
            completion(replies)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getTags(completion: @escaping ([Tag]) -> Void) {
        self.ref.child("tags").observe(DataEventType.value, with: { (snapshot) in
            let tagsStringArray = snapshot.value as? [String] ?? []
            var tagsArray = [Tag]()
            for stringTag in tagsStringArray {
                tagsArray.append(Tag(name: stringTag))
            }
            completion(tagsArray)
        })
    }
    
    func getUsers(completion: @escaping ([UserNF]) -> Void) {
        self.ref.child("users").observe(DataEventType.value, with: { (snapshot) in
            let dict = snapshot.value as? [String: AnyObject] ?? [:]
            var users = [UserNF]()
            for usersDictKey in dict {
                let tagsStringArray = dict[usersDictKey.key]?["tags"] as? [String] ?? []
                var tagsArray = [Tag]()
                for stringTag in tagsStringArray {
                    tagsArray.append(Tag(name: stringTag))
                }
                let username = dict[usersDictKey.key]?["username"] as? String ?? ""
                let email = dict[usersDictKey.key]?["email"] as? String ?? ""
                let uid = dict[usersDictKey.key]?["uid"] as? String ?? ""
                let totalScore = dict[usersDictKey.key]?["totalScore"] as? Int ?? 0
                let totalNumPosts = dict[usersDictKey.key]?["totalNumPosts"] as? Int ?? 0
                let totalNumSolutions = dict[usersDictKey.key]?["totalNumSolutions"] as? Int ?? 0
                let user = UserNF(uid: uid, email: email, username: username, tags: tagsArray, totalScore: totalScore, totalNumSolutions: totalNumSolutions, totalNumPosts: totalNumPosts)
                users.append(user)
            }
            
            completion(users)
        })
    }
    
    func getUserVoteHistory(postUID: String, ownerUID: String, completion: @escaping (Int) -> Void) {
        if let currentUserUID = self.currentUser?.uid {
            ref.child("/posts/\(postUID)/solutions/\(ownerUID)/scorers/\(currentUserUID)").observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                if snapshot.exists() {
                    if let scoreValue = snapshot.value as? Int {
                        completion(scoreValue)
                    }
                    
                } else {
                    completion(0)
                }
                
            }) { (error) in
                print(error.localizedDescription)
            }
            
        }
    }
    
    func getUserStatistics(userUID: String, completion: @escaping (Int, Int, Int) -> Void) {
        self.ref.child("users/\(userUID)/").observeSingleEvent(of: .value, with: { (snapshot) in
            if let responseDict = snapshot.value as? NSDictionary {
                if let totalScore = responseDict["totalScore"] as? Int, let totalNumPosts = responseDict["totalNumPosts"] as? Int, let totalNumSolutions = responseDict["totalNumSolutions"] as? Int {
                    completion(totalScore, totalNumPosts, totalNumSolutions)
                }
            } else {
                print("Error retrieving user statistics!")
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getTimestamp() -> [AnyHashable : Any] {
        return ServerValue.timestamp()
    }
    
    // MARK: - Update
    func updateUsersTotalScore(by addedScore: Int, forUserUID: String) {
        self.ref.child("users/\(forUserUID)/totalScore").runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if var currentScore = currentData.value as? Int, let currentUserUid = self.currentUser {
                currentScore += addedScore
                currentData.value = currentScore
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func updateSolutionScore(by addedScore: Int, postUID: String, ownerUID: String) {
        self.ref.child("posts/\(postUID)/solutions/\(ownerUID)/score").runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if var currentScore = currentData.value as? Int {
                currentScore += addedScore
                currentData.value = currentScore
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
    }
    
    func updateUsersVoteHistory(to score: Int, postUID: String, ownerUID: String) {
        if let currentUserUID = self.currentUser?.uid {
            self.ref.child("posts/\(postUID)/solutions/\(ownerUID)/scorers/\(currentUserUID)").setValue(score)
        }
    }
    
    // This function increases a post's popularity by 1 everytime a solution or reply is created under it
    func updatePostPopularity(by: Int, for postUID: String) {
        self.ref.child("posts/\(postUID)/popularity").runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if var currentPopularity = currentData.value as? Int {
                currentPopularity += 1
                currentData.value = currentPopularity
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Increment
    func incrementUsersSolutionCount(forUserUID: String) {
        self.ref.child("users/\(forUserUID)/totalNumSolutions").runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if var currentTotalNumSolutions = currentData.value as? Int {
                currentTotalNumSolutions += 1
                currentData.value = currentTotalNumSolutions
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func incrementUsersPostCount(forUserUID: String) {
        self.ref.child("users/\(forUserUID)/totalNumPosts").runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            if var currentTotalNumPosts = currentData.value as? Int {
                currentTotalNumPosts += 1
                currentData.value = currentTotalNumPosts
                return TransactionResult.success(withValue: currentData)
            }
            return TransactionResult.success(withValue: currentData)
        }) { (error, committed, snapshot) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Helper functions
    
    func tagsToStringsArray(tagArray: [Tag]) -> [String] {
        var tags = [String]()
        for tag in tagArray {
            tags.append(tag.name)
        }
        return tags
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
