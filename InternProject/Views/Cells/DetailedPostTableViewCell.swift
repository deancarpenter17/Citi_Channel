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
    @IBOutlet weak var repliesLbl: UIButton!
    @IBOutlet weak var answerTimeStampLbl: UILabel!
    
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
                thumbsUpBtn.setImage(#imageLiteral(resourceName: "Thumbs Up Blue"), for: .normal)
                thumbsDownBtn.setImage(#imageLiteral(resourceName: "Thumb Down"), for: .normal)
            case ScoreConstants.UserPreviouslyDownvoted:
                thumbsDownBtn.setImage(#imageLiteral(resourceName: "Thumbs Down Red"), for: .normal)
                thumbsUpBtn.setImage(#imageLiteral(resourceName: "Thumb Up"), for: .normal)
            case ScoreConstants.UserPreviouslyNotVoted:
                thumbsUpBtn.setImage(#imageLiteral(resourceName: "Thumb Up"), for: .normal)
                thumbsDownBtn.setImage(#imageLiteral(resourceName: "Thumb Down"), for: .normal)
            default:
                break
            }
        }
    }
    
    @IBAction func thumbsUpClicked(_ sender: Any) {
        if let ownerUID = ownerUID, let postUID = postUID, var score = score  {
            if userVoteHistory == ScoreConstants.UserPreviouslyNotVoted {
                score += ScoreConstants.UserPreviouslyUpvoted
                self.score = score
                userVoteHistory = ScoreConstants.UserPreviouslyUpvoted
                // Update solutions total score, which adds the current user to the "scorers" ref to keep track of votes
                FirebaseAPI.shared.updateSolutionScore(by: 1, postUID: postUID, ownerUID: ownerUID)
                
                // Update the solution owner's total score
                FirebaseAPI.shared.updateUsersTotalScore(by: ScoreConstants.UserPreviouslyUpvoted, forUserUID: ownerUID)
                
                // Update user's vote history
                FirebaseAPI.shared.updateUsersVoteHistory(to: 1, postUID: postUID, ownerUID: ownerUID)
            }
                
            else if userVoteHistory == ScoreConstants.UserPreviouslyUpvoted {
                score += ScoreConstants.UserPreviouslyNotVoted
                self.score = score
                userVoteHistory = ScoreConstants.UserPreviouslyNotVoted
                FirebaseAPI.shared.updateSolutionScore(by: -1, postUID: postUID, ownerUID: ownerUID)
                FirebaseAPI.shared.updateUsersTotalScore(by: -1, forUserUID: ownerUID)
                FirebaseAPI.shared.updateUsersVoteHistory(to: 0, postUID: postUID, ownerUID: ownerUID)
            }
                
            else if userVoteHistory == ScoreConstants.UserPreviouslyDownvoted {
                score += 2
                self.score = score
                userVoteHistory = ScoreConstants.UserPreviouslyUpvoted
                FirebaseAPI.shared.updateSolutionScore(by: 2, postUID: postUID, ownerUID: ownerUID)
                FirebaseAPI.shared.updateUsersTotalScore(by: 2, forUserUID: ownerUID)
                FirebaseAPI.shared.updateUsersVoteHistory(to: 1, postUID: postUID, ownerUID: ownerUID)
            }
        }
    }
    
    @IBAction func thumbsDownClicked(_ sender: Any) {
        if let ownerUID = ownerUID, let postUID = postUID, var score = score  {
            if userVoteHistory == ScoreConstants.UserPreviouslyNotVoted {
                score += ScoreConstants.UserPreviouslyDownvoted
                self.score = score
                userVoteHistory = ScoreConstants.UserPreviouslyDownvoted
                // Update solutions total score, which adds the current user to the "scorers" ref to keep track of votes
                FirebaseAPI.shared.updateSolutionScore(by: ScoreConstants.UserPreviouslyDownvoted, postUID: postUID, ownerUID: ownerUID)
                
                // Update the solution owner's total score
                FirebaseAPI.shared.updateUsersTotalScore(by: ScoreConstants.UserPreviouslyDownvoted, forUserUID: ownerUID)
                
                // Update user's vote history
                FirebaseAPI.shared.updateUsersVoteHistory(to: ScoreConstants.UserPreviouslyDownvoted, postUID: postUID, ownerUID: ownerUID)
            }
                
            else if userVoteHistory == ScoreConstants.UserPreviouslyUpvoted {
                score += -2
                self.score = score
                userVoteHistory = ScoreConstants.UserPreviouslyDownvoted
                FirebaseAPI.shared.updateSolutionScore(by: -2, postUID: postUID, ownerUID: ownerUID)
                FirebaseAPI.shared.updateUsersTotalScore(by: -2, forUserUID: ownerUID)
                FirebaseAPI.shared.updateUsersVoteHistory(to: -1, postUID: postUID, ownerUID: ownerUID)
            }
                
            else if userVoteHistory == ScoreConstants.UserPreviouslyDownvoted {
                score = ScoreConstants.UserPreviouslyNotVoted
                self.score = score
                userVoteHistory = ScoreConstants.UserPreviouslyUpvoted
                FirebaseAPI.shared.updateSolutionScore(by: 1, postUID: postUID, ownerUID: ownerUID)
                FirebaseAPI.shared.updateUsersTotalScore(by: 1, forUserUID: ownerUID)
                FirebaseAPI.shared.updateUsersVoteHistory(to: 0, postUID: postUID, ownerUID: ownerUID)
            }
        }
    }
}
