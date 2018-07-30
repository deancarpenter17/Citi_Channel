//
//  CustomDateFormatter.swift
//  InternProject
//
//  Created by Dean Carpenter on 7/30/18.
//  Copyright © 2018 Dean Carpenter. All rights reserved.
//

import Foundation
import UIKit

class CustomDateFormatter {
    
    static let currentTimezone = TimeZone.current
    
    static func shortDateTimeString(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YY 'at' hh:mm a"
        
        // Get user's current timezone
        dateFormatter.timeZone = TimeZone(identifier: self.currentTimezone.identifier)
        return dateFormatter.string(from: date)
    }
}
