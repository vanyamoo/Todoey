//
//  Item.swift
//  Todoey
//
//  Created by Vanya Mutafchieva on 29/11/2019.
//  Copyright © 2019 Vanya Mutafchieva. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Categorie.self, property: "items")
}
