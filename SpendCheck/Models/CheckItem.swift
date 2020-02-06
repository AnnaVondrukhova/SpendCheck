//
//  CheckItem.swift
//  SpendCheck
//
//  Created by Anya on 20/11/2019.
//  Copyright © 2019 Anna Vondrukhova. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class CheckItem: Object {
    var id: Int = 0
    var name: String = ""
    var price: Double = 0
    var quantity: Double = 0
    var categoryId: Int = 0
    
    var parent = LinkingObjects(fromType: Check.self, property: "checkItems")
    
    convenience init (json: JSON) {
        self.init()
    }
}
