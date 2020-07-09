//
//  CheckItem+CoreDataClass.swift
//  SpendCheck
//
//  Created by Anya on 02.07.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//
//

import Foundation
import CoreData

@objc(CheckItem)
public class CheckItem: NSManagedObject {
    static var classiD: Int64 = 0
    
    func configure(withItem item: Item) {
        self.id = CheckItem.classiD
        self.name = item.name
        self.price = Double(item.price/100)
        self.quantity = item.quantity
        self.sum = Double(item.price/100)
        
        CheckItem.classiD += 1
    }
}
