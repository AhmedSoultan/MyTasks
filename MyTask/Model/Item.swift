//
//  Item.swift
//  MyTask
//
//  Created by Ahmed Sultan on 9/26/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var date: Date?
    @objc dynamic var colour: String?
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
