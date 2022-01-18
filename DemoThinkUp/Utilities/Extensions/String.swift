//
//  String.swift
//  DemoThinkUp
//
//  Created by Diego Quimbo on 4/2/21.
//

import Foundation

extension String {
    func localized(bundle: Bundle = .main, tableName: String = "UILocalizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }
    
    public func localizedUsingFile(_ fileName: String, bundleLanguage: String? = nil, withComment comment: String) -> String {
        if let bundleLanguage = bundleLanguage,
            let path = Bundle.main.path(forResource: bundleLanguage, ofType: "lproj"),
            let bundle = Bundle(path: path) {
            
            return NSLocalizedString(self, tableName: fileName, bundle: bundle, value: "", comment: comment)
            
        } else {
            return NSLocalizedString(self, tableName: fileName, bundle: Bundle.main, value: "", comment: comment)
        }
    }
    
    public func localizedUsingFile(_ fileName: String) -> String {
        return localizedUsingFile(fileName, withComment: "")
    }
    
    public func localizedUsingMainFile() -> String {
        return localizedUsingFile(LocalizableStrings.main)
    }
}
