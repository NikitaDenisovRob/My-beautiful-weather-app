//
//  Forecas layer.swift
//  my weather
//
//  Created by Никита Денисов on 17.03.2022.
//

import Foundation
import UIKit

struct Forecast {
    var forecastArray:  [ForecastCollection] = []
    
    init() {
        forecastArray = [
            ForecastCollection(temperature: nil,isSelected: true, image: nil, time: "Сейчас"),
            ForecastCollection(temperature: nil,isSelected: false, image: nil, time: nil),
            ForecastCollection(temperature: nil,isSelected: false, image: nil, time: nil),
            ForecastCollection(temperature: nil,isSelected: false, image: nil, time: nil)
        ]
    }
    
    mutating func setTemperature(tempArray: [String]) {
        for i in 1...3 {
            forecastArray[i].temperature = tempArray[i - 1]
        }
    }
    
    mutating func setImage(imageNames: [String]) {
        for i in 1...3 {
            forecastArray[i].image = UIImage(named: imageNames[i - 1])
        }
    }
    
    mutating func setTime(timeArray: [String]) {
        for i in 1...3 {
            forecastArray[i].time = timeArray[i - 1]
        }
    }
    
    mutating func setFirst(temp: String, image: String) {
        forecastArray[0].temperature = temp
        forecastArray[0].image = UIImage(named: image)
    }
}

struct ForecastCollection {
    var temperature:    String?
    var isSelected:     Bool
    var image:          UIImage?
    var time:           String?
}
