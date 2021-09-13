//
//  ContentView.swift
//  Weather App
//
//  Created by Anthony Polka on 9/11/21.
//

import SwiftUI


struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemMaterial

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

struct ContentView: View {
   
    @State var data = [WeatherAPI]()
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
   
    var body: some View {
        ZStack{
            
            Color.clear
                .ignoresSafeArea()
            
            ScrollView{
            VStack{
                DayView{
                    
                    Rectangle()
                        .frame(width: 380, height: 380, alignment: .center)
                        .foregroundColor(.clear)
                        .overlay(Group{
                         
                            ForEach(data, id: \.id) { i in
                                
                                Text(String(format: "%0.f", i.current.temp) + "°")
                                    .font(.monospacedDigit(Font.system(size: 100).weight(.light))())
                                    .padding(.leading, 38)
                                 
                                Text(i.current.weather[0].main)
                                    .font(.custom("", size: 30))
                                    
                                HStack{
                                    
                                    Text("H:" + String(format: "%0.f" , i.daily[0].temp.max) + "°")
                                        .font(.custom("", size: 30))
                                    Text("L:" + String(format: "%0.f" , i.daily[0].temp.min) + "°")
                                        .font(.custom("", size: 30))
                                }
                            }
                        })
                    .padding(10)
                }
               
                DayView{
                    ScrollView(.horizontal){
                        HStack{
                            ForEach(0..<27, id: \.self){ i in
                               
                                ForEach(data, id: \.id) { data in
                                    HourlyView(hour: data.hourly[i].dt,
                                               temp: data.hourly[i].temp,
                                               rainChance: data.hourly[i].pop * 100,
                                               sky:data.hourly[i].weather[0].main,
                                               sunset: self.data[0].current.sunset,
                                               sunrise: self.data[0].current.sunrise)
                                }
                            }
                        }
                    }
                }
                .padding(.leading)
                .padding(.trailing)
                //MARK: DayView
                DayView{
                    VStack{
                        ForEach(0..<7, id: \.self) { i in
                            
                            ForEach(data, id: \.id) { data in
                                Divider()
                                DailyView(day: getDate(date: data.daily[i].dt),
                                          high: data.daily[i].temp.max,
                                          low: data.daily[i].temp.min,
                                          image: "sun.max.fill",
                                          rainChance: data.daily[i].pop * 100)
                            }
                        }
                    }
                }
                .padding(.leading)
                .padding(.trailing)
                LazyVGrid(columns: self.columns){
                DayView{
                    VStack{
                    Rectangle()
                        .frame(width: 190, height: 190, alignment: .center)
                        .foregroundColor(.clear)
                        .overlay(Group{
                            HStack(){
                              Rectangle()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.clear)
                                .overlay(Image(systemName: "aqi.medium")
                                            .resizable()
                                            .scaledToFit())
                            Text("Humidity")
                                .font(.custom("", size: 20))
                            }
                            .padding(.top, 10)
                            .padding(.trailing, 40)
                            
                            ForEach(self.data, id: \.id) { i in
                                Text(String(format: "%0.f", i.current.humidity) + "%")
                                    .font(.custom("", size: 50))
                                    .padding()
                                Spacer()
                                
                            }
                        })
                    }
                }
                    DayView{
                        VStack{
                        Rectangle()
                            .frame(width: 190, height: 190, alignment: .center)
                            .foregroundColor(.clear)
                            .overlay(Group{
                                HStack(){
                                  Rectangle()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.clear)
                                    .overlay(Image(systemName: "thermometer")
                                                .resizable()
                                                .scaledToFit())
                                Text("Feels like")
                                    .font(.custom("", size: 20))
                                }
                                .padding(.top, 10)
                                .padding(.trailing, 40)
                                
                                ForEach(self.data, id: \.id) { i in
                                    Text(String(format: "%0.f", i.current.feels_like) + "°")
                                        .font(.custom("", size: 50))
                                        .padding()
                                    Spacer()
                                }
                            })
                        }
                    }
                }
                .padding()
                }
            }
        }
        .background(Image("ClearNight"))
        .onAppear(){
            Data().fetchInfo{ i in
                data.append(i)
                
               
            }
        }
    }
    func getDate(date: Double) -> String{
            let date = Date(timeIntervalSince1970: date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            dateFormatter.timeZone = .current
            let localDate = dateFormatter.string(from: date)
        
        if localDate == dateFormatter.string(from: Date()){
            return "Today"
        }
            return localDate
    }
}
struct DayView<Content:View>: View{
    let content: Content
    init(@ViewBuilder content: ()-> Content){
        self.content = content()
    }
    var body: some View{
        ZStack{
            content
        }
        .background(Blur(style: .systemUltraThinMaterialLight))
        .cornerRadius(25)
        .shadow(radius: 10)
        .overlay(Group{
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.black, lineWidth: 1)
                .foregroundColor(.clear)
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
}
