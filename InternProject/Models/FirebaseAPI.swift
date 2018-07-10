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
import GoogleSignIn

class FirebaseAPI: NSObject, GIDSignInDelegate, GIDSignInUIDelegate {
    
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
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        // Set the FirebaseAPI database reference
        FirebaseAPI.shared.ref = Database.database().reference()
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url, sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
    }
    
    // The method should call the handleURL method of the GIDSignIn instance, which will properly handle the URL that your application receives at the end of the authentication process.
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            print("Error signing user in!")
            print(error.localizedDescription)
            return
        }
        
        //get a Google ID token and Google access token from the GIDAuthentication object and exchange them for a Firebase credential:
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                print("Error exchanging Google/Firebase tokens!")
                print(error.localizedDescription)
                return
            }
            // User is signed in
            print("**********user is signed in*************)")
            
            // If user created an account, go to tags screen. otherwise go to home screen
            if let user = self.currentUser {
                // Check to see if user has logged in before
                self.ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
                    let users = snapshot.value as? NSDictionary
                    // if user exists in Firebase database
                    if let _ = users?[user.uid] {
                        DispatchQueue.main.async {
                            let homeTabController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeTabController")
                            self.appDelegate.navigateTo(viewController: homeTabController)
                        }
                    } else {
                        if let user = self.currentUser {
                            // Register user in Firebase database
                            let currentUser = [
                                "name": user.displayName,
                                "email": user.email,
                                "uid": user.uid,
                                ]
                            
                            self.ref.child("users/\(user.uid)").setValue(currentUser)
                            DispatchQueue.main.async {
                                let rootController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TagNavController")
                                self.appDelegate.navigateTo(viewController: rootController)
                            }
                        }
                    }
                }) { (error) in
                    print("Error querying all users!")
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    
    func signInWithGoogle(shouldSignInSilently: Bool) {
        // This silently signs the user in automatically, if they've logged in through google before
        shouldSignInSilently ? GIDSignIn.sharedInstance().signInSilently() : GIDSignIn.sharedInstance().signIn()
    }
    
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
    
    // THIS FUNCTION IS ONLY USED TO LOAD DEFAULT TAGS INITIALLY IN FIREBASE
    func tempSave(tags: [Tag]) {
        // Convert Tag array into a valid JSON object (arrays are not valid)
        var tagsDict = [String: String]()
        for tag in tags {
            tagsDict[tag.name] = tag.name
        }
        self.ref.child("tags").setValue(tagsDict)
    }
    
}
