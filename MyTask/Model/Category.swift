//
//  Category.swift
//  MyTask
//
//  Created by Ahmed Sultan on 9/26/19.
//  Copyright © 2019 Ahmed Sultan. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var colour: String?
    let items = List<Item>()
}
