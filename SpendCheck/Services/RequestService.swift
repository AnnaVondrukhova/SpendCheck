//
//  RequestService.swift
//  SpendCheck
//
//  Created by Anya on 28/11/2019.
//  Copyright © 2019 Anna Vondrukhova. All rights reserved.
//

import Foundation
import RxSwift
import RxRealm
import SwiftyJSON

class RequestService {
    
    static func getParams(receivedString: String) -> [String:String] {
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
    
    //MARK: проверяем существование чека
    static func checkExist(receivedString: String) {
        print ("existence check begin")
        
        
        //разбираем полученную строку на словарь с параметрами
        var params = getParams(receivedString: receivedString)
        print ("params loaded")
        
        let dateFormatter = DateFormatter()
        var oldDate = Date()
        dateFormatter.dateFormat = "yyyyMMdd'T'HHmmss"
        if dateFormatter.date(from: params["t"]!) != nil {
            oldDate = dateFormatter.date(from: params["t"]!)!
        } else {
            dateFormatter.dateFormat = "yyyyMMdd'T'HHmm"
            if dateFormatter.date(from: params["t"]!) != nil {
                oldDate = dateFormatter.date(from: params["t"]!)!
            } else {
                NSLog ("receivedString: unknown date format")
            }
        }
        print(oldDate)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        params["t"] = dateFormatter.string(from: oldDate)
        params["s"] = "\(Int(round(Double(params["s"]!)!*100)))"
        print(params["s"]!)
        
        print(String(describing: params))
//
//        let url = URL(string: "https://proverkacheka.nalog.ru:9999/v1/ofds/*/inns/*/fss/9289000100346765/operations/1/tickets/97660?fiscalSign=4179925410&date=2020-05-18T15:52:00&sum=53182")
        let url = URL(string: "https://proverkacheka.nalog.ru:9999/v1/ofds/*/inns/*/fss/\(params["fn"]!)/operations/\(params["n"]!)/tickets/\(params["i"]!)?fiscalSign=\(params["fp"]!)&date=\(params["t"]!)&sum=\(params["s"]!)")
        
        print(String(describing: url))
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 7
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            var result: Observable<Check>
            let httpResponse = response as? HTTPURLResponse
            
            //если ответ получен, то:
            if httpResponse != nil {
                let statusCode = httpResponse!.statusCode
                print("Status code = \(statusCode)")
                NSLog("Status code = \(statusCode)")
                
                if statusCode == 204 {
                    RequestService.loadData(receivedString: receivedString)
                    NSLog("Check existence request: success, loading data")
                }
                else {
                    let check = Check(error: "\(statusCode)", qrString: receivedString, jsonString: nil)
                    result = RealmServices.addCheck(check: check)
                    print("case error: \(statusCode)")
                    NSLog("Check existence request: case error \(statusCode)")
                }
            }
            else {
                let check = Check(error: "\(001)", qrString: receivedString, jsonString: nil)
                result = RealmServices.addCheck(check: check)
                if error!._code == NSURLErrorTimedOut {
                    print("case .failure (timeout)\(error!.localizedDescription)")
                    NSLog("Check existence request: case failure (timeout) \(error!.localizedDescription)")
                }
                print("case .failure \(error!.localizedDescription)")
                NSLog("Check existence request: case failure \(error!.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    //MARK: загружаем данные с сайта ФНС
    static func loadData(receivedString: String){
        print("loadData func begin")
        
//        let user = UserDefaults.standard.string(forKey: "user")
//        let password = UserDefaults.standard.string(forKey: "password")
        let user = "+79031827753"
        let password = "309179"
        let loginData = String(format: "%@:%@", user, password).data(using: String.Encoding.utf8)!
        let base64LoginData = loginData.base64EncodedString()
        
        //разбираем полученную строку на словарь с параметрами
        let params = getParams(receivedString: receivedString)
        print ("params loaded")

//        let url = URL(string: "https://proverkacheka.nalog.ru:9999/v1/ofds/*/inns/*/fss/9289000100346765/operations/1/tickets/97660?fiscalSign=4179925410&date=2020-05-18T15:52:00&sum=53182")
        let url = URL(string: "https://proverkacheka.nalog.ru:9999/v1/inns/*/kkts/*/fss/\(params["fn"]!)/tickets/\(params["i"]!)?fiscalSign=\(params["fp"]!)&sendToEmail=no")
        
        var request = URLRequest(url: url!)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("Basic \(base64LoginData)", forHTTPHeaderField: "Authorization")
        request.setValue("", forHTTPHeaderField: "Device-Id")
        request.setValue("", forHTTPHeaderField: "Device-OS")
        request.httpMethod = "GET"
        request.timeoutInterval = 7
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            var result: Observable<Check>
            let httpResponse = response as? HTTPURLResponse
            
            if httpResponse != nil {
                let statusCode = httpResponse!.statusCode
                print("Status code = \(statusCode)")
                NSLog("Status code = \(statusCode)")
                
                if statusCode == 200 {
                    let json = JSON(data!)
                    if json.rawString() != "null" {
                        print(json)
                        let check = Check(error: nil, qrString: receivedString, jsonString: json.rawString())
                        let checkItems = json["document"]["receipt"]["items"].compactMap {CheckItem(json: $0.1)}
                        check.addCheckItems(checkItems)
                        result = RealmServices.addCheck(check: check)
                        print ("case success")
                        NSLog("Alamofire request: case success")
                    }
                        //если json пустой, записываем строку в базу с jsonString = nil и error != nil
                    else {
                        let check = Check(error: "001", qrString: receivedString, jsonString: nil)
                        result = RealmServices.addCheck(check: check)
                        print ("case error: empty json")
                        NSLog("Check items request: case error, empty json")
                    }
                }
                    //если возвращается не 200, то
                else {
                    let check = Check(error: "\(httpResponse!.statusCode)", qrString: receivedString, jsonString: nil)
                        result = RealmServices.addCheck(check: check)
                        print("case error: \(String(describing: httpResponse!.statusCode))")
                        NSLog("Check items request: case error \(String(describing: httpResponse!.statusCode))")
                    }
                }
            //если httpResponse == nil, то
                else {
                    let check = Check(error: "\(001)", qrString: receivedString, jsonString: nil)
                    result = RealmServices.addCheck(check: check)
                    if error!._code == NSURLErrorTimedOut {
                        print("case .failure (timeout)\(error!.localizedDescription)")
                        NSLog("Check items request: case failure (timeout) \(error!.localizedDescription)")
                    }
                    print("case .failure \(error!.localizedDescription)")
                    NSLog("Check items request: case failure \(error!.localizedDescription)")
                }
            }
        task.resume()
        }
}
