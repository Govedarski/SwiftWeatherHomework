//
//  DataManagerRealm.swift
//  HomeworkWeather
//
//  Created by Alex Partulov on 25.01.23.
//

import Foundation
import RealmSwift

class DataManagerRealm{
    static let realm = try! Realm(configuration: realmConfig)
    
    class func dropDatabase() {
        try! realm.write{
            realm.deleteAll()
        }
    }
    
    static var realmConfig: Realm.Configuration{
        var config = Realm.Configuration()
        config.deleteRealmIfMigrationNeeded = true
        config.schemaVersion = 1
        return config
    }
}
