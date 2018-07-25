//
//  UserNF.swift
//  InternProject
//
//  Created by Dean Carpenter on 7/25/18.
//  Copyright © 2018 Dean Carpenter. All rights reserved.
//

import Foundation

// Named this UserNF because there is already a User class that's part of Firebase, but doesn't contain all the fields we need. NF here stands for non-firebase
struct UserNF {
    var uid: String
    var email: String
    var username: String
    var tags: [Tag]
    var totalScore: Int
    var totalNumSolutions: Int
    var totalNumPosts: Int
}
