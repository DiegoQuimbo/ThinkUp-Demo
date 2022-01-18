//
//  LocalizableStrings.swift
//  DemoThinkUp
//
//  Created by Diego Quimbo on 4/2/21.
//

import UIKit
import Foundation

struct LocalizableStrings {
    
    fileprivate init() {}
    
    static let error = "Error"
    static let main = "Main"
}

/**
 type of language that will have the app, if it will support more languages, please added here, as a case, to select the correct localization file
 
 - System: the device language
 */
enum Language: String {
    /// Device Language
    case System = "System"
}

/**
 * Handles language and localization settings
 */
struct Localization {
    
    fileprivate init() {}
    
    /// base language, its gonna say what language its be used, by default, the system language
    static var baseLanguage: Language = .System
}
