//
//  AppDelegate.swift
//  InternProject
//
//  Created by Dean Carpenter on 6/26/18.
//  Copyright © 2018 Dean Carpenter. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseAPI.shared.appDelegate = self
        FirebaseAPI.shared.setupFirebase()
        
        if let user = FirebaseAPI.shared.currentUser {
            if let displayName = user.displayName, let email = user.email {
                print("Current User Display Name: \(displayName)")
                print("Current User Email: \(email)")
            }
            
            let homeTabController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeTabController")
            self.navigateTo(viewController: homeTabController)
        } else {
            //User Not logged in
            print("not logged in..........")
        }
        return true
    }
    
    // Used so non-view controller classes can trigger a UI change when user is logged in successfully. Possibly bad design
    func navigateTo(viewController: UIViewController) {
        self.window?.rootViewController = viewController
    }
    
   
}

