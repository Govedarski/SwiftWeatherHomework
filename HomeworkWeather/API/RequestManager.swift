//
//  RequestManager.swift
//  HomeworkWeather
//
//  Created by Alex Partulov on 18.01.23.
//

import Foundation
import Alamofire

class RequestManager{
//    private static let errorMessageURL = "Error: Failed to create URL!"
//    private static let errorMessageNoData = "Error: No data!"
//    private static let errorMessageDecode = "Error: Failed to decode data!"
//
//    private static func createUrlFor(latitude:String, longitude:String) -> URL? {
//        let urlAsString = "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&current_weather=true&hourly=temperature_2m,relativehumidity_2m,weathercode,pressure_msl,visibility"
//        print(latitude, longitude)
//        return URL(string: urlAsString)
//    }
//
//    class func getRequest (url:URL) -> URLRequest{
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        return request
//    }
//
//    class func getWeatherIn(location:Location, completion: @escaping (Weather?) -> Void) {
//        guard let url = RequestManager.createUrlFor(latitude: location.latitude,
//                                        longitude: location.longitude)
//        else{
//            print(self.errorMessageURL)
//            return completion(nil)
//        }
//
//        let request = self.getRequest(url: url)
//
//        let task = URLSession.shared.dataTask(with: request, completionHandler: {
//            (data, response, error ) in
//            guard let data = data
//            else{
//                print(self.errorMessageNoData)
//                return completion(nil)
//            }
//            guard let weather = try? JSONDecoder().decode(Weather.self, from: data)
//            else {
//                print(self.errorMessageDecode)
//                return completion(nil)
//            }
//            return completion(weather)
//        })
//
//        task.resume()
//    }
    
    class func fetchDataAlamofire(location:LocationRealm?,  completion: @escaping ()->() ){
        guard let location = location else {
            return
        }
        let temperatureUnit = UserSettings.temperatureUnit == TemperatureUnit.Celsius.rawValue ? "celsius" : "fahrenheit"
        let urlAsString = "https://api.open-meteo.com/v1/forecast?latitude=\(location.latitude)&longitude=\(location.longitude)&current_weather=true&hourly=temperature_2m,relativehumidity_2m,weathercode,pressure_msl,visibility,precipitation,temperature_80m&temperature_unit=\(temperatureUnit)&past_days=7"
        
        AF.request(urlAsString).responseDecodable(of:Weather.self, completionHandler: {
            response in
            guard let weatherData = response.value
            else {
                return
            }
            let timeNow = self.getCurrentTime()
            let weather = WeatherRealm(id: location.id, weather: weatherData, lastUpdated:timeNow)
            try! DataManagerRealm.realm.write{
                DataManagerRealm.realm.add(weather, update: .all)
                location.weather = weather
            }
            
        
            completion()
        })
    }
    
    class func getCurrentTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let currentTime = dateFormatter.string(from: Date())
        return currentTime
    }
}
