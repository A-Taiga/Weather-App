//
//  HourlyView.swift
//  Weather App
//
//  Created by Anthony Polka on 9/11/21.
//

import SwiftUI

struct HourlyView: View {
 
    
    @State var hour: Double = 1631373248
    @State var temp: Double = 90
    @State var rainChance: Float = 100
    @State var sky: String = "Rain"
    @State var sunset: Double = 1631406742
    @State var sunrise: Double = 1631361859

    var body: some View {
        VStack{
           
            Text(self.getHour(date: self.hour))
                .padding()
           Spacer()
            Text(String(format: "%.0f", self.temp) + "°")
                .padding()
        }
        .overlay(Group{
            
            let sunDown = self.getSunset(hour: self.getHour(date: self.hour), sunsetHour: self.getHour(date: self.sunset))
            
            let sunUp = self.getSunset(hour: self.getHour(date: self.hour), sunsetHour: self.getHour(date: self.sunrise))
            
            let theHour = self.getNight(date: self.hour)
            let moon = (self.getNight(date: self.sunset))
            let sun = self.getNight(date: self.sunrise)
              
            self.getClouds(key: self.sky, rain: self.rainChance, sunset: sunDown, sunrise: sunUp, hour: theHour, moon: moon, sun: sun)
                  .renderingMode(.original)
                  .resizable()
                  .scaledToFit()
                  .padding()
     
            
        })
        
        .frame(width: 100, height: 120, alignment: .center)
        .background(Color.clear)
    }
    
    
    func getHour(date: Double) -> String{
            let date = Date(timeIntervalSince1970: date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h a"
            dateFormatter.timeZone = .current
            let localDate = dateFormatter.string(from: date)
        return localDate
    }
    func getNight(date: Double) -> String{
            let date = Date(timeIntervalSince1970: date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH"
            dateFormatter.timeZone = .current
            let localDate = dateFormatter.string(from: date)
        return localDate
    }
    func getClouds(key: String, rain: Float, sunset: Bool, sunrise: Bool, hour: String, moon: String, sun: String) -> Image{
        
       
        
        if sunset{
            return Image(systemName: "sunset.fill")
        }
        if sunrise{
            return Image(systemName: "sunrise.fill")
        }
        if hour > moon{
            
            switch rain{
            case 0..<10:        return Image(systemName: "moon.stars.fill")
            case 10..<20:       return Image(systemName: "cloud.moon.fill")
            case 20..<100:      return Image(systemName: "cloud.moon.rain.fill")
            default:            return Image(systemName: "photo.fill")
            }
        }
        if hour < sun {
            
            switch rain{
            case 0..<10:        return Image(systemName: "moon.stars.fill")
            case 10..<20:       return Image(systemName: "cloud.moon.fill")
            case 20..<100:      return Image(systemName: "cloud.moon.rain.fill")
            default:            return Image(systemName: "photo.fill")
            }
        }
        switch key {
        case "Thunderstorm": return Image(systemName: "cloud.bolt.rain.fill")
        case "Drizzle":      return Image(systemName: "cloud.drizzle.fill")
        case "Rain":         return Image(systemName: "cloud.rain.fill")
        case "Clear":        return Image(systemName: "sun.max.fill")
        case "Clouds":       return Image(systemName: "cloud.fill")
        default:             return Image(systemName: "photo.fill")
        }
        
    }
    func getSunset(hour: String, sunsetHour: String) -> Bool{
        return hour == sunsetHour ? true : false
    }
    func getSunrise(hour: String, sunriseHour: String) -> Bool{
        return hour == sunriseHour ? true : false
    }
}


struct HourlyView_Previews: PreviewProvider {
    static var previews: some View {
        HourlyView().previewLayout(.sizeThatFits)
    }
}
