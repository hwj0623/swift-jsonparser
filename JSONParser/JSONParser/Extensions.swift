//
//  Extensions.swift
//  JSONParser
//
//  Created by 윤지영 on 18/10/2018.
//  Copyright © 2018 JK. All rights reserved.
//

import Foundation

extension String {
    func removeWhiteSpaces() -> String {
        return self.components(separatedBy: .whitespaces).joined()
    }
    func hasSideSquareBrackets() -> Bool {
        return (self.count > 1 && self.first == "[" && self.last == "]")
    }
    func hasDoubleQuotation() -> Bool {
        return (self.count > 1 && self.first == "\"" && self.last == self.first)
    }
    func trimSquareBrackets() -> String {
        return self.trimmingCharacters(in: CharacterSet(charactersIn: "[]"))
    }
    func trimDoubleQuotation() -> String {
        return self.trimmingCharacters(in: CharacterSet(charactersIn: "\""))
    }
    func splitByComma() -> [String] {
        return self.split(separator: ",").map({ String($0) })
    }
}