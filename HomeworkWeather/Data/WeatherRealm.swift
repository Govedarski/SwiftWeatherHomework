//
//  WeatherRealm.swift
//  HomeworkWeather
//
//  Created by Alex Partulov on 25.01.23.
//

import Foundation
import RealmSwift

class WeatherRealm :Object{
    @Persisted (primaryKey: true) var id:Int
    @Persisted var time:String
    @Persisted var temperature:Double
    @Persisted var winddirection:Int
    @Persisted var windspeed:Double
    @Persisted var weathercode:Int
    @Persisted var lastUpdated:String
    @Persisted var temperatureHistory = List<Double>()
    @Persisted var precipitationHistory = List<Double>()
    @Persisted var timeHistory = List<String>()
    @Persisted var humidityHistory = List<Double>()
    @Persisted var pressureHistory = List<Double>()
    @Persisted var visibilityHistory = List<Double>()
    
    convenience init(id:Int, weather:Weather,lastUpdated:String) {
        self.init()
        self.id = id
        self.lastUpdated = lastUpdated
        self.time = weather.time
        self.temperature = weather.temperature
        self.winddirection = weather.winddirection
        self.windspeed = weather.windspeed
        self.weathercode = weather.weathercode
        self.temperatureHistory.append(objectsIn: weather.hourly.temperature_80m)
        self.precipitationHistory.append(objectsIn: weather.hourly.precipitation)
        self.timeHistory.append(objectsIn: weather.hourly.time)
        self.humidityHistory.append(objectsIn: weather.hourly.relativehumidity_2m)
        self.pressureHistory.append(objectsIn: weather.hourly.pressure_msl)
        self.visibilityHistory.append(objectsIn: weather.hourly.visibility)
    }
    
    var humidity:Double{
        return self.getCurrent(Array(self.humidityHistory))!
    }
    var pressure:Double{
        return self.getCurrent(Array(self.pressureHistory))!
    }
    var visibility:Double{
        return self.getCurrent(Array(self.visibilityHistory))!
    }
    
    private func getCurrent(_ values:[Double]) -> Double? {
        guard let index = self.timeHistory.firstIndex(of: self.time)
        else{
            print("Error!")
            return nil
        }
        return Double(values[index])
    }
}
