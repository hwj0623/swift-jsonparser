//
//  JsonArray.swift
//  JSONParser
//
//  Created by hw on 14/05/2019.
//  Copyright © 2019 JK. All rights reserved.
//

import Foundation

struct JsonArray : JsonParsable {
    
    private (set) var arrayList : [JsonParsable]
    
    init(){
        self.arrayList = [JsonParsable]()
    }
    
    init(_ input: [JsonParsable]){
        self.init()
        for index in 0..<input.count {
            arrayList.append(input[index])
        }
    }
    
    mutating func add(value: JsonParsable){
        self.arrayList.append(value)
    }
    
    var description: String {
        get {
            var result = "\(TokenSplitSign.squareBracketStart.description) "
            for index in 0..<arrayList.count-1{
                let cur = arrayList[index].description
                result += " \(arrayList[index].description),"
            }
            result += " \(arrayList[arrayList.count-1].description) \(TokenSplitSign.squareBracketEnd.description)"
            return result
        }
    }
}
