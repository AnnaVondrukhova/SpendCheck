//
//  File.swift
//  SpendCheck
//
//  Created by Anya on 20/11/2019.
//  Copyright © 2019 Anna Vondrukhova. All rights reserved.
//

import Foundation
import RealmSwift

class Check: Object {
    @objc dynamic var qrString = ""
    @objc dynamic var error: String?
    @objc dynamic var jsonString: String?
    var checkItems = List<CheckItem>()
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
        
        self.checkDate = self.getCheckDate(qrString: self.qrString)
        print ("check date \(self.checkDate as Any)")
    }
    
    func addCheckItems(_ checkItems: [CheckItem]) {
        self.checkItems.append(objectsIn: checkItems)
    }
    
    func getCheckDate(qrString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyyMMdd'T'HHmmss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let start = qrString.index(qrString.startIndex, offsetBy: 2)
        var end = qrString.index(qrString.startIndex, offsetBy: 17)
        var range = start..<end
        if dateFormatter.date(from: String(qrString[range])) != nil {
            return dateFormatter.date(from: String(qrString[range]))!
        } else {
            dateFormatter.dateFormat = "yyyyMMdd'T'HHmm"
            end = qrString.index(qrString.startIndex, offsetBy: 15)
            range = start..<end
            if dateFormatter.date(from: String(qrString[range])) != nil {
                return dateFormatter.date(from: String(qrString[range]))!
            } else {
                NSLog ("QrStringInfoObject: unknown date format")
                return Date()
                
            }
        }
    }
}
