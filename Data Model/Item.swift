//
//  Item.swift
//  Todoey
//
//  Created by Vanya Mutafchieva on 25/11/2019.
//  Copyright © 2019 Vanya Mutafchieva. All rights reserved.
//

import Foundation


// Encodable encodes model objects into a plist, JSON
// Encodable + Decodable = Codable
struct Item: Codable {
    var title: String = ""
    var done: Bool = false
}
