//
//  Post.swift
//  InternProject
//
//  Created by Dean Carpenter on 7/16/18.
//  Copyright © 2018 Dean Carpenter. All rights reserved.
//

import Foundation

struct Post {
    var ownerUID: String
    var ownerName: String
    var description: String
    var tags: [Tag]
    var title: String
    var postUID: String
}
