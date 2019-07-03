//
//  Extensions.swift
//  Weekly
//
//  Created by Truman, Christopher on 7/3/19.
//  Copyright © 2019 Truman. All rights reserved.
//

import Foundation

extension String {
    func stringByRemoving(characters: [Character]) -> String {
        return String(self.filter({ !characters.contains($0) }))
    }
    
    func stringByRemoving(subStrings: [String]) -> String {
        var cleanedString = self
        for string in subStrings {
            cleanedString = cleanedString.replacingOccurrences(of: string, with: "")
        }
        return cleanedString
    }
}
