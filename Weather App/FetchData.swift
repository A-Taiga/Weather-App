//
//  FetchData.swift
//  Weather App
//
//  Created by Anthony Polka on 9/11/21.
//

import Foundation
import SwiftUI
 
struct Weather: Codable {
    
    let main: String
    let description: String
    
}
struct Current: Codable {
    
    let dt: Double
    let sunrise: Double
    let sunset: Double
    let temp: Double
    let feels_like: Double
    let pressure: Double
    let humidity: Double
    let dew_point: Double
    let uvi: Double
    let clouds: Double
    let visibility: Double
    let wind_speed: Double
    let wind_deg: Double
    let wind_gust: Double
    let weather: [Weather]
    
   
}
struct Minutely: Codable {
   
    
}
struct HourlyWeather: Codable {
  
    let main: String
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case main
        case description
    }
}
struct Hourly: Codable {
    let dt: Double
    let temp: Double
    let feels_like: Double
    let pressure: Double
    let  humidity: Double
    let dew_point: Double
    let uvi: Double
    let clouds: Double
    let visibility: Double
    let wind_speed: Double
    let wind_deg: Double
    let wind_gust: Double
    let weather: [HourlyWeather]
    let pop: Float
    
   
}
struct DailyTemp: Codable {
    
    let day: Double
    let min: Double
    let max: Double
    let night: Double
    let eve: Double
    let morn: Double
}
struct Daily: Codable {
   
    let dt: Double
    let sunrise: Double
    let sunset: Double
    let moonrise: Double
    let moon_phase: Double
    let temp: DailyTemp
   //let feels_like: FeelsLike
    let pressure: Double
    let humidity: Double
    let dew_point: Double
    let wind_speed: Double
    let wind_deg: Double
    let wind_gust: Double
    //let weather: [DailyWeather]
    let clouds: Double
    let pop: Float
    let uvi: Double
}
struct WeatherAPI: Codable {
  
    let current: Current
    let hourly: [Hourly]
    let daily: [Daily]
}
var apiKey = "377efb0876b0908dda0e8c1e3cafb273&units"
var link = "https://api.openweathermap.org/data/2.5/onecall?lat=30.079729&lon=-95.417686&appid=\(apiKey)=imperial"

class Data: ObservableObject {
    
    @Published var data = []
    
    func fetchInfo(completion: @escaping (WeatherAPI) -> ()){
        
        guard let url = URL(string: link ) else {
            print("error")
            return
            
        }
        URLSession.shared.dataTask(with: url) {data, response, error in
            let jsonResult = try! JSONDecoder().decode(WeatherAPI.self, from: data!)
            
            DispatchQueue.main.async {
                
               
               completion(jsonResult)
                for i in 0..<24 {
                    self.data.append(jsonResult.hourly[i].dt)
                }
                
                
                
            }
        }.resume()
    }
    static func imageToDisplay(rain: Float) -> Image{
       
        switch rain {
        case 0..<10:         return Image(systemName: "sun.max.fill")
        case 10..<20:   return Image(systemName: "cloud.drizzle.fill")
        case 20...100:  return Image(systemName: "cloud.rain.fill")
        default:        return Image(systemName: "photo")
        }
    }
    }
extension Weather: Identifiable {
  var id: UUID { return UUID() }
}
extension Current: Identifiable {
  var id: UUID { return UUID() }
}
extension Minutely: Identifiable {
  var id: UUID { return UUID() }
}
extension HourlyWeather: Identifiable {
  var id: UUID { return UUID() }
}
extension Hourly: Identifiable {
  var id: UUID { return UUID() }
}
extension DailyTemp: Identifiable {
  var id: UUID { return UUID() }
}
extension Daily: Identifiable {
  var id: UUID { return UUID() }
}
extension WeatherAPI: Identifiable {
  var id: UUID { return UUID() }
}

