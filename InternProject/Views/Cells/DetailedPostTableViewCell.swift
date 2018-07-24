//
//  DetailedPostTableViewCell.swift
//  InternProject
//
//  Created by Jaylin Phipps on 7/7/18.
//  Copyright © 2018 Dean Carpenter. All rights reserved.
//

import Foundation
import UIKit

class DetailedPostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var answerDescriptionText: UITextView!
    @IBOutlet weak var answerTimeStampLbl: UILabel!
    @IBOutlet weak var answerTitleLbl: UILabel!
    @IBOutlet weak var solutionScore: UILabel!
    @IBOutlet weak var upvoteButton: UIButton!
    @IBOutlet weak var downvoteButton: UIButton!
    
    var ownerUID: String?
    var postUID: String?
    
    // total score for the solution
    var score: Int? {
        didSet {
            solutionScore.text = score?.description
        }
    }
    // how to user voted previously
    var userVoteHistory: Int? {
        didSet {
            switch self.userVoteHistory {
            case ScoreConstants.UserPreviouslyUpvoted:
                upvoteButton.backgroundColor = UIColor.blue
            case ScoreConstants.UserPreviouslyDownvoted:
                downvoteButton.backgroundColor = UIColor.red
            default:
                break
            }
        }
    }
    
    @IBAction func thumbsUpClicked(_ sender: Any) {
        if userVoteHistory == ScoreConstants.UserPreviouslyNotVoted, let ownerUID = ownerUID, let postUID = postUID {
            if var score = score {
                score += 1
                self.score = score
                userVoteHistory = ScoreConstants.UserPreviouslyUpvoted
            }
            // Update solutions total score, which adds the current user to the "scorers" ref to keep track of votes
            FirebaseAPI.shared.updateSolutionScore(by: 1, postUID: postUID, ownerUID: ownerUID)
            
            // Update the solution owner's total score
            FirebaseAPI.shared.updateUsersTotalScore(by: 1, forUserUID: ownerUID)
            
        }
    }
    
    @IBAction func thumbsDownClicked(_ sender: Any) {
        if userVoteHistory == ScoreConstants.UserPreviouslyNotVoted, let ownerUID = ownerUID, let postUID = postUID {
            if var score = score {
                score -= 1
                self.score = score
                userVoteHistory = ScoreConstants.UserPreviouslyDownvoted
            }
            // Update solutions total score, which adds the current user to the "scorers" ref to keep track of votes
            FirebaseAPI.shared.updateSolutionScore(by: -1, postUID: postUID, ownerUID: ownerUID)
            
            // Update the solution owner's total score
            FirebaseAPI.shared.updateUsersTotalScore(by: -1, forUserUID: ownerUID)
        }
    }
    
}
