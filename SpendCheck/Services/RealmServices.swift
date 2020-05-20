//
//  RealmServices.swift
//  SpendCheck
//
//  Created by Anya on 22/11/2019.
//  Copyright © 2019 Anna Vondrukhova. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxRealm


class RealmServices {
    
    static func withRealm<T>(_ operation: String, action: (Realm) throws -> T) -> T? {
      do {
        let realm = try Realm()
        return try action(realm)
      } catch let err {
        print("Failed \(operation) realm with error: \(err)")
        return nil
      }
    }
    
   static func addCheck(check: Check) -> Observable<Check> {
        let result = withRealm("adding check") { realm -> Observable<Check> in
            print("adding check")
            realm.beginWrite()
            realm.add(check, update: .modified)
            try realm.commitWrite()
            return .just(check)
        }
        return result ?? .error(RealmErrors.addingFailed)
    }
    
    static func getChecks() -> Observable<Results<Check>> {
        let result = withRealm("getting checks") { result -> Observable<Results<Check>> in
            let realm = try Realm()
            let checks = realm.objects(Check.self)
            return Observable.collection(from: checks)
        }
        return result ?? .empty()
    }
}
