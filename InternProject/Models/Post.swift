//
//  Post.swift
//  InternProject
//
//  Created by Dean Carpenter on 7/16/18.
//  Copyright © 2018 Dean Carpenter. All rights reserved.
//

import Foundation

struct Post: Hashable {
    var hashValue: Int {
        return ownerUID.hashValue ^ postDate.timeIntervalSince1970.hashValue
    }
    var ownerUID: String
    var ownerName: String
    var description: String
    var tags: [Tag]
    var title: String
    var postUID: String
    var postDate: Date
    var popularity: Int
}
