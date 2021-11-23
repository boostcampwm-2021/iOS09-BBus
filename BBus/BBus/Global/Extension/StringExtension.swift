//
//  StringExtension.swift
//  BBus
//
//  Created by 최수정 on 2021/11/11.
//

import Foundation

extension String {
    func ranges(of substring: String) -> [Range<String.Index>] {
        var ranges = [Range<String.Index>]()
        var lowerBound = self.startIndex
        let upperBound = self.endIndex
        
        while let range = self.range(of: substring,
                                     options: [],
                                     range: lowerBound..<upperBound) {
            ranges.append(range)
            lowerBound = range.upperBound
        }
        
        return ranges
    }

    func prefixNumber() -> String {
        var result = ""
        for character in self {
            if character.isNumber {
                result += String(character)
            }
            else {
                break
            }
        }
        return result
    }
}
