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
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var price: Double = 0
    @objc dynamic var sum: Double = 0
    @objc dynamic var quantity: Double = 0
    @objc dynamic var categoryId: Int = 0
    
    var parent = LinkingObjects(fromType: Check.self, property: "checkItems")
    
    static var classiD = 0
    
    convenience init (json: JSON) {
        self.init()
        
        self.id = CheckItem.classiD
        self.name = json["name"].stringValue
        self.price = json["price"].doubleValue/100
        self.sum = json["sum"].doubleValue/100
        self.quantity = json["quantity"].doubleValue
        
        CheckItem.classiD += 1
    }
}
