//
//  PostTableViewCell.swift
//  InternProject
//
//  Created by Jaylin Phipps on 7/7/18.
//  Copyright © 2018 Dean Carpenter. All rights reserved.
//

import Foundation
import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postTitleLbl: UILabel!
    @IBOutlet weak var tagLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    
    //    @IBOutlet weak var postTitleLbl: UILabel!
    //    @IBOutlet weak var nameLbl: UILabel!
    //    @IBOutlet weak var tagLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

