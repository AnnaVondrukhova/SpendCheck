//
//  Check+CoreDataClass.swift
//  SpendCheck
//
//  Created by Anya on 02.07.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Check)
public class Check: NSManagedObject {
    func configure(error: String?, qrString: String, jsonString: String?, shop: String = "", sum: Double = 0) {
        
        self.error = error
        self.qrString = qrString
        self.jsonString = jsonString
        self.mDate = Date()
        print ("current date \(self.mDate!)")
        
        self.checkDate = SupportingFuncs.getCheckDate(qrString: self.qrString!)
        print ("check date \(self.checkDate as Any)")
        
        self.shop = shop
        self.sum = sum
    }
    
}
