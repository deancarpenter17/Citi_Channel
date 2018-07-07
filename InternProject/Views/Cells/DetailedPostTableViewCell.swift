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
    @IBOutlet weak var answerThumbsUpCount: UILabel!
    @IBOutlet weak var answerThumbsDownCount: UILabel!
    @IBOutlet weak var answerTitleLbl: UILabel!
    
//    @IBOutlet weak var answerTitleLbl: UILabel!
//    @IBOutlet weak var answerDescriptionText: UITextView!
//    @IBOutlet weak var answerTimeStampLbl: UILabel!
//    @IBOutlet weak var answerThumbsUpCount: UILabel!
//    @IBOutlet weak var answerThumbsDownCount: UILabel!
    
    var thumbsUpCount = 0
    var thumbsDownCount = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func thumbsUpClicked(_ sender: Any) {
        thumbsUpCount += 1
        answerThumbsUpCount.text = thumbsUpCount.description
    }
    
    @IBAction func thumbsDownClicked(_ sender: Any) {
        thumbsDownCount -= 1
        answerThumbsDownCount.text = thumbsDownCount.description
    }
    
}
