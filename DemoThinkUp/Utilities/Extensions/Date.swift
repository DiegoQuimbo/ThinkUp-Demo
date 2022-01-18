//
//  Date.swift
//  DemoThinkUp
//
//  Created by Diego Quimbo on 4/2/21.
//

import UIKit

extension Date {
    /// Get date string with the format MM/dd/yyyy
    func formattedStringDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: self)
    }
}
