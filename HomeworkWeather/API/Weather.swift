//
//  Weather.swift
//  HomeworkWeather
//
//  Created by Alex Partulov on 18.01.23.
//

import Foundation

struct Hourly:Codable{
    var temperature_80m:[Double]
    var precipitation:[Double]
    var time:[String]
    var relativehumidity_2m:[Double]
    var pressure_msl:[Double]
    var visibility:[Double]
}

struct CurrentWeather:Codable{
    var temperature:Double
    var time:String
    var winddirection:Int
    var windspeed:Double
    var weathercode:Int
}

struct Weather:Codable{
    var current_weather:CurrentWeather
    var hourly:Hourly
    
    private func getCurrent(_ values:[Double]) -> Double? {
        guard let index = self.hourly.time.firstIndex(of: self.current_weather.time)
        else{
            print("Error!")
            return nil
        }
        return Double(values[index])
    }
}


extension  Weather {
    var time:String{
        self.current_weather.time
    }
    var temperature:Double{
        self.current_weather.temperature
    }
    var winddirection:Int{
        self.current_weather.winddirection
    }
    var windspeed:Double{
        self.current_weather.windspeed
    }
    var weathercode:Int{
        self.current_weather.weathercode
    }
    var humidity:Double?{
        self.getCurrent(self.hourly.relativehumidity_2m)
    }
    var pressure:Double?{
        self.getCurrent(self.hourly.relativehumidity_2m)
    }
    var visibility:Double?{
        self.getCurrent(self.hourly.relativehumidity_2m)
    }
}
