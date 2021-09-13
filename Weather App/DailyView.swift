//
//  DailyView.swift
//  Weather App
//
//  Created by Anthony Polka on 9/11/21.
//

import SwiftUI



struct DailyView: View {
   
    var day: String = "Day"
    var high: Double = 100
    var low: Double = 80
    var image: String = "sun.max.fill"
    var rainChance: Float = 100
    
    var body: some View {
        ZStack{
               Rectangle()
                .frame(width: 400, height: 60, alignment: .center)
                .foregroundColor(.clear)
           
                
                .overlay(Group{
                    ZStack{
                        Data.imageToDisplay(rain: self.rainChance)
                        .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .padding()

                        
                        HStack{
                            Text(self.day)
                                .font(.title.monospacedDigit())
                                .padding()
                            
                            Spacer()
                            VStack(alignment: .leading){
                                Text(String(format: "%0.00f" , self.rainChance) + "%")
                                
                            }
                            .padding()
                            VStack(alignment: .center){
                                HStack{
                                    Text("H: " + String(format: "%0.f", self.high) + "°")
                                }
                                HStack{
                                    Text("L: " + String(format: "%0.f", self.low) + "°")
                                }
                            }
                        .padding()
                            
                    }
                }
            })
        }
    }
   
}

struct DailyView_Previews: PreviewProvider {
    static var previews: some View {
        DailyView()
            .previewLayout(.sizeThatFits)
    }
}
