//
//  StringExtensions.swift
//  InternProject
//
//  Created by Dean Carpenter on 7/13/18.
//  Copyright © 2018 Dean Carpenter. All rights reserved.
//

import Foundation

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
}
