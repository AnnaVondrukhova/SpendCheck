//
//  RequestService.swift
//  SpendCheck
//
//  Created by Anya on 28/11/2019.
//  Copyright © 2019 Anna Vondrukhova. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

class RequestService {

 
    //MARK: проверяем существование чека
    static func checkExist(receivedString: String/*, completion: @escaping (_ error: String?, _ qrString: String, _ jsonString: String?) -> ()*/) {
        print ("existence check begin")
        
        //разбираем полученную строку на словарь с параметрами
        var params = SupportingFuncs.getParamsFromString(receivedString: receivedString)
        
        guard let oldDate = SupportingFuncs.getDate(fromString: params["t"]!) else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        params["t"] = dateFormatter.string(from: oldDate)
        params["s"] = "\(Int(round(Double(params["s"]!)!*100)))"

        print(String(describing: params))
//
//        let url = URL(string: "https://proverkacheka.nalog.ru:9999/v1/ofds/*/inns/*/fss/9289000100346765/operations/1/tickets/97660?fiscalSign=4179925410&date=2020-05-18T15:52:00&sum=53182")
        let url = URL(string: "https://proverkacheka.nalog.ru:9999/v1/ofds/*/inns/*/fss/\(params["fn"]!)/operations/\(params["n"]!)/tickets/\(params["i"]!)?fiscalSign=\(params["fp"]!)&date=\(params["t"]!)&sum=\(params["s"]!)")

        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 7
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            let httpResponse = response as? HTTPURLResponse
            
            //если ответ получен, то:
            if httpResponse != nil {
                let statusCode = httpResponse!.statusCode
                print("Status code = \(statusCode)")

                if statusCode == 204 {
                    RequestService.loadData(receivedString: receivedString)
                    print("Check existence request: success, loading data")
                }
                else {
                    SaveService.saveCheck(error: "\(statusCode)", qrString: receivedString, jsonString: nil, items: [])
                    
                    print("Check existence request: case error \(statusCode)")
                }
            }
            else {
                SaveService.saveCheck(error: "\(001)", qrString: receivedString, jsonString: nil, items: [])
                if error!._code == NSURLErrorTimedOut {
                    print("Check existence request: case failure (timeout) \(error!.localizedDescription)")
                }
                print("Check existence request: case failure \(error!.localizedDescription)")
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
        let params = SupportingFuncs.getParamsFromString(receivedString: receivedString)
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
            
            let httpResponse = response as? HTTPURLResponse
            
            if httpResponse != nil {
                let statusCode = httpResponse!.statusCode
                print("Status code = \(statusCode)")
                
                if statusCode == 200 {
                    guard let data = data else { return }
                    let jsonString = String(data: data, encoding: String.Encoding.utf8) ?? "null"
                    
                    if jsonString != "null" {
                        do {
                            let decoder = JSONDecoder()
                            let check = try decoder.decode(JSONCheck.self, from: data)
                            print(check.document.receipt.items.first?.name)
                            DispatchQueue.main.async {
                                SaveService.saveCheck(error: nil, qrString: receivedString, jsonString: jsonString, items: check.document.receipt.items)
                            }
                        } catch let error {
                            print("Json decoding error: ", error)
                        }
                    }
                    
                    
                    
//                    let json = JSON(data!)
//                    if json.rawString() != "null" {
//                        print(json)
 //                       saveCheck(error: nil, qrString: receivedString, jsonString: json.rawString())
//                        let checkItems = json["document"]["receipt"]["items"].compactMap {CheckItem(json: $0.1)}
//                        check.addCheckItems(checkItems)
//                        print ("case success")
//                    }
                //если json пустой, записываем строку в базу с jsonString = nil и error != nil
                    else {
                        DispatchQueue.main.async {
                            SaveService.saveCheck(error: "001", qrString: receivedString, jsonString: nil, items: [])
                            print("Check items request: case error, empty json")
                        }
                        
                    }
                }
                //если возвращается не 200, то
                else {
                    DispatchQueue.main.async {
                        SaveService.saveCheck(error: "\(httpResponse!.statusCode)", qrString: receivedString, jsonString: nil, items: [])
                        print("Check items request: case error \(String(describing: httpResponse!.statusCode))")
                    }
                }
            }
            //если httpResponse == nil, то
            else {
                
                DispatchQueue.main.async {
                    SaveService.saveCheck(error: "\(001)", qrString: receivedString, jsonString: nil, items: [])
                }
                    
                if error!._code == NSURLErrorTimedOut {
                    print("Check items request: case failure (timeout) \(error!.localizedDescription)")
                }
                    
                print("Check items request: case failure \(error!.localizedDescription)")
            }
        }
    task.resume()
    }
}
