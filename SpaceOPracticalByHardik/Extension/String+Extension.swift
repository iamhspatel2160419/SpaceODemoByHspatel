//
//  String+Extension.swift
//  SpaceOPracticalByHardik
//
//  Created by Apple on 10/12/20.
//

import Foundation
extension String
{
   func firstCharacterLowerCase() -> String
    {
        let first = self[self.startIndex ..< self.index(startIndex, offsetBy: 1)]
        let rest = self[self.index(startIndex, offsetBy: 1) ..< self.endIndex]
        return first.lowercased() + rest
    }
    
    func firstCharacterUpperCase() -> String {
        let first = self[self.startIndex ..< self.index(startIndex, offsetBy: 1)]
        let rest = self[self.index(startIndex, offsetBy: 1) ..< self.endIndex]
        return first.uppercased() + rest
    }
    
    func trimString() -> String {
        return self.trimmingCharacters(
            in: CharacterSet.whitespacesAndNewlines)
 
    }
    func trim() -> String
    {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
}

