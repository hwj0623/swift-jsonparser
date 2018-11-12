//
//  File.swift
//  JSONParser
//
//  Created by 김장수 on 12/11/2018.
//  Copyright © 2018 JK. All rights reserved.
//

import Foundation

protocol SwiftArray {
    func parsedData() -> (ints: [Int], bools: [Bool], strings: [String], totalCount: Int)
}

struct JSONData: SwiftArray {
    private var ints: [Int]
    private var bools: [Bool]
    private var strings: [String]
    private var totalCount: Int
    
    init(ints: [Int], bools: [Bool], strings: [String]) {
        self.ints = ints
        self.bools = bools
        self.strings = strings
        self.totalCount = ints.count + bools.count + strings.count
    }
    
    func parsedData() -> (ints: [Int], bools: [Bool], strings: [String], totalCount: Int) {
        return (ints: self.ints, bools: self.bools, strings: self.strings, totalCount: self.totalCount)
    }
}