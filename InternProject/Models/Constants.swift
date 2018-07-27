//
//  Constants.swift
//  InternProject
//
//  Created by Dean Carpenter on 7/23/18.
//  Copyright © 2018 Dean Carpenter. All rights reserved.
//

import Foundation

struct ScoreConstants {
    static let PostScore = 10
    // The person who creates this solution gets this many point initially
    static let SolutionScore = 3
    // This is the inital upvote score that is given to a solution by default
    static let InitialSolutionUpvotes = 0
    // Each time a solution is upvoted, increment by this amount
    static let UpvoteIncrementScore = 1
    static let AcceptedSolutionScore = 10
    static let UserPreviouslyUpvoted = 1
    static let UserPreviouslyDownvoted = -1
    static let UserPreviouslyNotVoted = 0
}
