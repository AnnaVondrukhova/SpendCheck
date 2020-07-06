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
    
    static func saveCheck(error: String?, qrString: String, jsonString: String?, items: [Item]) {
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
            
            for item in items {
                let checkItem = CheckItem(context: context)
                checkItem.configure(withItem: item)
                checkItems?.add(checkItem)
            }
            
            check.configure(error: error, qrString: qrString, jsonString: jsonString)
            check.checkItems = checkItems
            
            try context.save()
            print("Check saved")
            
            let results = try context.fetch(fetchRequest)
            print ("CoreData date: ", results.first?.checkDate, results.first?.mDate)
        } catch let error {
            print(error.localizedDescription)
        }
    }

}
