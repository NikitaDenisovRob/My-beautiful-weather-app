//
//  model.swift
//  my weather
//
//  Created by Никита Денисов on 09.03.2022.
//

import Foundation
import UIKit

//MARK: - weather model
class NetworkModel {
    internal var delegate:              NetworkDelegate?
    internal var mainInformation:       WeatherAPI?
    internal var weatherForecast:       WeatherForecastAPI?
    
    
    //Net variable
    private let apiKey                  = // {Your api key here}
    private let sessionConfiguration    =  URLSessionConfiguration.default
    private lazy var session            = URLSession.shared
    private let decoder                 = JSONDecoder()
    
    func loadDataFromServer(lat: Double, lon: Double, with language: Int) {
        let lang = languageToString(IntFromStorage: language)
        sessionConfiguration.waitsForConnectivity = false
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)\(lang)") else {
            return
        }
        guard let forecastUrl = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=\(apiKey)\(lang)") else {return}
        session.dataTask(with: url) {[weak self](data, response, error) in
            guard let strongSelf = self else {return}
            guard error == nil else {
                return
            }
            if let dataFromServer = data {
                let weatherObject = try? strongSelf.decoder.decode(WeatherAPI.self, from: dataFromServer)
                
                if weatherObject != nil {
                    strongSelf.mainInformation = weatherObject
                    strongSelf.delegate?.updateDefaultAndSet()
                }
            }
        }.resume()
        session.dataTask(with: forecastUrl) {[weak self](data, response, error) in
            guard let strongSelf = self else {return}
            guard error == nil else {
                return
            }
            if let dataFromServer = data {
                let weatherObject = try? strongSelf.decoder.decode(WeatherForecastAPI.self, from: dataFromServer)
                
                if weatherObject != nil {
                    strongSelf.weatherForecast = weatherObject
                    strongSelf.delegate?.updateForecast()
                }
            }
        }.resume()
    }
    
    func getForecastWeather(index: Int) -> Double {
        return round(weatherForecast!.list[index].main.temp)
    }
    
    func getDescriptionOfForecast(index: Int) -> String {
        return weatherForecast!.list[index].weather[0].weatherDescription
    }

    
    func getForecastWindSpeed(index: Int) -> Double {
        return weatherForecast!.list[index].wind.speed
    }
    
    func getForecastHumidity(index: Int) -> Int {
        return weatherForecast!.list[index].main.humidity
    }
    
    func getForecastFeeling(index: Int) -> Double {
        return weatherForecast!.list[index].main.feelsLike
    }
    
    func getForecastAttrebutes(index: Int) -> (weather: Double,
                                     desc: String,
                                     wind: Double,
                                     hum: Int,
                                     feels: Double) {
        return (getForecastWeather(index: index),
                getDescriptionOfForecast(index: index),
                getForecastWindSpeed(index: index),
                getForecastHumidity(index: index),
                getForecastFeeling(index: index))
    }
    
    private func languageToString(IntFromStorage: Int) -> String{
        if IntFromStorage == 0 {
            return "&lang=ru"
        } else {
            return ""
        }
    }
}

// MARK: - Get from WeatherAPI
struct WeatherAPI: Codable {
    let coord:          Coord
    let weather:        [Weather]
    let base:           String
    let main:           Main
    let visibility:     Int
    let wind:           Wind
    let clouds:         Clouds
    let dt:             Int
    let sys:            Sys
    let timezone, id:   Int
    let name:           String
    let cod:            Int
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax:  Double
    let pressure, humidity:                 Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike  = "feels_like"
        case tempMin    = "temp_min"
        case tempMax    = "temp_max"
        case pressure, humidity
    }
}

// MARK: - Sys
struct Sys: Codable {
    let type, id:           Int?
    let country:            String
    let sunrise, sunset:    Int
}

// MARK: - Weather
struct Weather: Codable {
    let id:                             Int
    let main, weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}
 
// MARK: - Get from weatherForecastAPI

struct WeatherForecastAPI: Codable {
    let cod:        String
    let message:    Int
    let cnt:        Int?
    let list:       [List]
    let city:       City
}

// MARK: - City
struct City: Codable {
    let id:                                     Int
    let name:                                   String
    let coord:                                  Coord
    let country:                                String
    let population, timezone, sunrise, sunset:  Int
}

// MARK: - List
struct List: Codable {
    let dt:         Int
    let main:       MainClass
    let weather:    [Weather]
    let clouds:     Clouds
    let wind:       Wind
    let visibility: Int
    let pop:        Double
    let sys:        Syst
    let dtTxt:      String

    enum CodingKeys: String, CodingKey {
           case dt, main, weather, clouds, wind, visibility, pop, sys
           case dtTxt = "dt_txt"
       }
}

// MARK: - MainClass
struct MainClass: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity: Int
    let tempKf: Double
    
    enum CodingKeys: String, CodingKey {
           case temp
           case feelsLike   = "feels_like"
           case tempMin     = "temp_min"
           case tempMax     = "temp_max"
           case pressure
           case seaLevel    = "sea_level"
           case grndLevel   = "grnd_level"
           case humidity
           case tempKf      = "temp_kf"
       }
}

// MARK: - Syst
struct Syst: Codable {
    let pod: Pod
}

enum Pod: String, Codable {
    case d = "d"
    case n = "n"
}


// MARK: - Wind
struct Wind: Codable {
    let speed:  Double
    let deg:    Int
    let gust:   Double?
}
