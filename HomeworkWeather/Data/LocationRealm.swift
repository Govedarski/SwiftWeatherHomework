//
//  LocationRealm.swift
//  HomeworkWeather
//
//  Created by Alex Partulov on 24.01.23.
//

import Foundation
import RealmSwift

class LocationRealm : Object {
    @Persisted (primaryKey: true) var id:Int
    @Persisted var name:String
    @Persisted var latitude:String
    @Persisted var longitude:String
    @Persisted var isDefault:Bool
    @Persisted var weather:WeatherRealm?

    
    
    convenience init(name: String, latitude: String, longitude: String, isDefault: Bool, weather: WeatherRealm? = nil) {
        self.init()
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.isDefault = isDefault
        self.weather = weather
        self.id += self.getId()
    }
    
    private func getId() -> Int{
        return (DataManagerRealm.realm.objects(LocationRealm.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}

