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
            // If user is signed in, transfer to TagViewController if they haven't chosen tags, else go to home screen
            let rootController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TagNavController")
            self.appDelegate.navigateTo(viewController: rootController)
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
    }
    
}
