//
//  SaveService.swift
//  SpendCheck
//
//  Created by Anya on 03.07.2020.
//  Copyright © 2020 Anna Vondrukhova. All rights reserved.
//

import Foundation
import CoreData

class SaveService {
    
    static func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    static func saveCheck(error: String?, qrString: String, jsonString: String?, shop: String = "", sum: Double = 0, items: [Item]) {
 //       SaveService.clearDB()
        let context = getContext()
        var check: Check
        guard let entity = NSEntityDescription.entity(forEntityName: "Check", in: context) else {return}
        
        let fetchRequest: NSFetchRequest<Check> = Check.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "qrString == %@", qrString)
        
        do {
            let checks = try context.fetch(fetchRequest)
            if checks.isEmpty {
                check = Check(entity: entity, insertInto: context)
            } else {
                check = checks.first!
            }
            
            let checkItems = check.checkItems?.mutableCopy() as? NSMutableOrderedSet
            
            if check.checkItems?.count == 0{
                for item in items {
                    let checkItem = CheckItem(context: context)
                    checkItem.configure(withItem: item)
                    checkItems?.add(checkItem)
                }
                
                check.checkItems = checkItems
            }
            
            check.configure(error: error, qrString: qrString, jsonString: jsonString, shop: shop, sum: sum)
            
            try context.save()
            print("Check saved")
            
//            let results = try context.fetch(fetchRequest)
//            print ("CoreData date: ", results.first?.checkDate, results.first?.mDate)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    static func clearDB() {
        let context = getContext()
        let fetchRequest: NSFetchRequest<CheckItem> = CheckItem.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            for result in results {
                let resultData = result as! NSManagedObject
                context.delete(resultData)
            }
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }

}
