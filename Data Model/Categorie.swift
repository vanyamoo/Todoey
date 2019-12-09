//
//  Categorie.swift
//  Todoey
//
//  Created by Vanya Mutafchieva on 29/11/2019.
//  Copyright © 2019 Vanya Mutafchieva. All rights reserved.
//

import Foundation
import RealmSwift

class Categorie: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}

