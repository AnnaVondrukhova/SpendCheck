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
    dynamic var uid: Int = 0
    dynamic var error: String?
    dynamic var qrString = ""
    dynamic var jsonString: String?
    var checkItems = List<CheckItem>()
    dynamic var checkDate: Date?
    dynamic var mDate: Date?
}
