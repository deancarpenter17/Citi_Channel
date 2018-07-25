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
    
    @IBOutlet weak var answerNameLbl: UILabel!
    @IBOutlet weak var answerDescriptionLbl: UILabel!
    @IBOutlet weak var solutionScoreLbl: UILabel!
    @IBOutlet weak var thumbsUpBtn: UIButton!
    @IBOutlet weak var thumbsDownBtn: UIButton!
    
    
    var ownerUID: String?
    var postUID: String?
    
    // total score for the solution
    var score: Int? {
        didSet {
            solutionScoreLbl.text = score?.description
        }
    }
    // how to user voted previously
    var userVoteHistory: Int? {
        didSet {
            switch self.userVoteHistory {
            case ScoreConstants.UserPreviouslyUpvoted:
                thumbsUpBtn.backgroundColor = UIColor.blue
            case ScoreConstants.UserPreviouslyDownvoted:
                thumbsDownBtn.backgroundColor = UIColor.red
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
