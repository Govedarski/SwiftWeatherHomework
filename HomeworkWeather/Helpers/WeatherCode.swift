//
//  WeatherCode.swift
//  HomeworkWeather
//
//  Created by Alex Partulov on 19.01.23.
//

import UIKit

struct WeatherDestricpion{
    var description:String
    var imageName:String
    
    var image:UIImage?{
        return UIImage(systemName: self.imageName)
    }
}

struct WeatherCode{
    static let clearSky = WeatherDestricpion(description: "Clear sky", imageName: "sun.max")
    static let cloudy = WeatherDestricpion(description: "Cloudy", imageName: "cloud")
    static let fog = WeatherDestricpion(description: "Fog", imageName: "cloud.fog")
    static let drizzle = WeatherDestricpion(description: "Drizzle", imageName: "cloud.drizzle")
    static let rain = WeatherDestricpion(description: "Rain", imageName: "cloud.rain")
    static let snowFall = WeatherDestricpion(description: "Snow fall", imageName: "snow")
    static let rainShowers = WeatherDestricpion(description: "Rain showers", imageName: "cloud.heavyrain")
    static let snowShowers = WeatherDestricpion(description: "Snow showers", imageName: "cloud.snow")
    static let thunderstorm = WeatherDestricpion(description: "Thunderstorm", imageName: "cloud.bolt")
    
    static func getWeatherCondition(code: Int) -> WeatherDestricpion? {
        switch code {
            // Clear sky
        case 0:
            return self.clearSky
            // Mainly clear, partly cloudy, and overcast - Mainly clear съм го оставил тук, защото в API, са групирани заедно.
        case 1, 2, 3:
            return self.cloudy
            // Fog and depositing rime fog
        case 45, 48:
            return self.fog
            // Drizzle: Light, moderate, and dense intensity
            // Freezing Drizzle: Light and dense intensity
        case 51, 53, 55, 56, 57:
            return self.drizzle
            // Rain: Slight, moderate and heavy intensity
            // Freezing Rain: Light and heavy intensity
        case 61, 63, 65, 66, 67:
            return self.rain
            // Snow fall: Slight, moderate, and heavy intensity
            // Snow grains
        case 71, 72, 75, 77:
            return self.snowFall
            // Rain showers: Slight, moderate, and violent
        case 80, 81, 82:
            return self.rainShowers
            // Snow showers slight and heavy
        case 85, 86:
            return self.snowShowers
            // Thunderstorm: Slight or moderate
            // Thunderstorm with slight and heavy hail
        case 95, 96, 99:
            return self.thunderstorm
        default:
            return nil
        }
    }
    
}
