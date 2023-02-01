//
//  UserSettings.swift
//  HomeworkWeather
//
//  Created by Alex Partulov on 23.01.23.
//
import Foundation

enum TemperatureUnit:String {
    case Celsius = "°C"
    case Fahrenheit = "°F"
}
//
//struct Location {
//    let name:String
//    let latitude:String
//    let longitude:String
//}

class UserSettings{
    static private let data = UserDefaults.standard
    static let tempUnitKey = "tempUnit"
    static var temperatureUnit: String? {
        get {
            return data.value(forKey: self.tempUnitKey) as? String
        }
        set {
            self.data.setValue(newValue, forKey: self.tempUnitKey)
        }
    }
}
