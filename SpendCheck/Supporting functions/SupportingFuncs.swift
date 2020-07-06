//
//  SupportingFuncs.swift
//  SpendCheck
//
//  Created by Anya on 02.07.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//

import Foundation

class SupportingFuncs {
    
    //разбираем на параметры строку из QR-кода
    static func getParamsFromString(receivedString: String) -> [String:String] {
        let params = receivedString
        .components(separatedBy: "&")
        .map { $0.components(separatedBy: "=") }
        .reduce([String: String]()) { result, param in
            var dict = result
            let key = param[0]
            let value = param[1]
            dict[key] = value
            return dict
        }
        return params
    }
    
    //получаем дату из параметра t
    static func getDate(fromString string: String) -> Date? {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyyMMdd'T'HHmmss"
        if dateFormatter.date(from: string) != nil {
            return dateFormatter.date(from: string)!
        } else {
            dateFormatter.dateFormat = "yyyyMMdd'T'HHmm"
            if dateFormatter.date(from: string) != nil {
                return dateFormatter.date(from: string)!
            } else {
                print("func getDate: unknown date format")
                return nil
            }
        }
    }
    
    static func getCheckDate(qrString: String) -> Date {
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
                print("func getCheckDate: unknown date format")
                return Date()
                
            }
        }
    }
}
