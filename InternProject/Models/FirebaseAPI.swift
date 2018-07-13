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
    
    // MARK: Firebase Authentication
    
    func setupFirebase() {
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        
        // Set the FirebaseAPI database reference
        FirebaseAPI.shared.ref = Database.database().reference()
    }
    
    //    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
    //        // ...
    //        if let error = error {
    //            print("Error signing user in!")
    //            print(error.localizedDescription)
    //            return
    //        }
    //
    //        //get a Google ID token and Google access token from the GIDAuthentication object and exchange them for a Firebase credential:
    //        guard let authentication = user.authentication else { return }
    //        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
    //                                                       accessToken: authentication.accessToken)
    //
    //
    //        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
    //            if let error = error {
    //                print("Error exchanging Google/Firebase tokens!")
    //                print(error.localizedDescription)
    //                return
    //            }
    //            // User is signed in
    //            print("**********user is signed in*************)")
    //
    //            // If user created an account, go to tags screen. otherwise go to home screen
    //            if let user = self.currentUser {
    //                // Check to see if user has logged in before
    //                self.ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
    //                    let users = snapshot.value as? NSDictionary
    //                    // if user exists in Firebase database
    //                    if let _ = users?[user.uid] {
//                            DispatchQueue.main.async {
//                                let homeTabController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeTabController")
//                                self.appDelegate.navigateTo(viewController: homeTabController)
//                            }
    //                    } else {
    //                        if let user = self.currentUser {
    //                            // Register user in Firebase database
    //                            let currentUser = [
    //                                "name": user.displayName,
    //                                "email": user.email,
    //                                "uid": user.uid,
    //                                ]
    //
    //                            self.ref.child("users/\(user.uid)").setValue(currentUser)
//                                DispatchQueue.main.async {
//                                    let rootController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TagNavController")
//                                    self.appDelegate.navigateTo(viewController: rootController)
    //                            }
    //                        }
    //                    }
    //                }) { (error) in
    //                    print("Error querying all users!")
    //                    print(error.localizedDescription)
    //                }
    //            }
    //        }
    //    }
    //
    func signoutUser() {
        try? Auth.auth().signOut()
        print("User signed out")
        let splashNavVC: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SplashNavVC") as UIViewController
        self.appDelegate.navigateTo(viewController: splashNavVC)
    }
    
    // Mark: - Firebase Database Ops
    
    // sets the user's tags
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
