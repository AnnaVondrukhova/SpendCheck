//
//  File.swift
//  SpendCheck
//
//  Created by Anya on 20/11/2019.
//  Copyright © 2019 Anna Vondrukhova. All rights reserved.
//

import Foundation
import RealmSwift

class Check1: Object {
    @objc dynamic var qrString = ""
    @objc dynamic var error: String?
    @objc dynamic var jsonString: String?
    var checkItems = List<CheckItem1>()
    @objc dynamic var checkDate: Date?
    @objc dynamic var mDate: Date?
    
    override static func primaryKey() -> String? {
        return "qrString"
    }
    
    convenience init(error: String?, qrString: String, jsonString: String?) {
        self.init()
        
        self.error = error
        self.qrString = qrString
        self.jsonString = jsonString
        self.mDate = Date()
        print ("current date \(self.mDate!)")
        
//        self.checkDate = self.getCheckDate(qrString: self.qrString)
//        print ("check date \(self.checkDate as Any)")
    }
    
    func addCheckItems(_ checkItems: [CheckItem1]) {
        self.checkItems.append(objectsIn: checkItems)
    }
    
    
}
