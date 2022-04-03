//
//  Main model.swift
//  my weather
//
//  Created by Никита Денисов on 24.03.2022.
//

import Foundation

class WeekNetworkModel {
    internal var delegate:      NetworkWeekDelegate?
    internal var pulledData:    Welcome?
    
    //Net variable
    private let apiKey                  = // {Your api key here}
    private let sessionConfiguration    =  URLSessionConfiguration.default
    private lazy var session            = URLSession.shared
    private let decoder                 = JSONDecoder()
    
    func loadDataFromServer(lat: Double, lon: Double, with language: Int) {
        let lang = languageToString(IntFromStorage: language)
        sessionConfiguration.waitsForConnectivity = false
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&exclude=minutely,hourly&appid=\(apiKey)\(lang)") else {
            return
        }
        session.dataTask(with: url) {[weak self](data, response, error) in
            guard let strongSelf = self else {return}
            guard error == nil else {
                return
            }
            if let dataFromServer = data {
                let weatherObject = try? strongSelf.decoder.decode(Welcome.self, from: dataFromServer)
                if weatherObject != nil {
                    strongSelf.pulledData = weatherObject
                    strongSelf.delegate?.setBottomOptions()
                }
                
            }
        }.resume()
    }
    private func languageToString(IntFromStorage: Int?) -> String {
        if let lang = IntFromStorage {
            if lang == 0 {
                return "&lang=ru"
            } else {
                return ""
            }
        } else {return "&lang=ru"}
    }
}

// MARK: - Welcome
struct Welcome: Codable {
    let lat, lon:       Double
    let timezone:       String
    let timezoneOffset: Int
    let current:        Current
    let daily:          [Daily]

    enum CodingKeys: String, CodingKey {
        case lat, lon, timezone
        case timezoneOffset = "timezone_offset"
        case current, daily
    }
}

// MARK: - Current
struct Current: Codable {
    let dt, sunrise, sunset:    Int
    let temp, feelsLike:        Double
    let pressure, humidity:     Int
    let dewPoint:               Double
    let uvi:                    Double?
    let clouds, visibility:     Int
    let windSpeed:              Double
    let windDeg:                Int
    let windGust:               Double?
    let weather:                [Weather]

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike  = "feels_like"
        case pressure, humidity
        case dewPoint   = "dew_point"
        case uvi, clouds, visibility
        case windSpeed  = "wind_speed"
        case windDeg    = "wind_deg"
        case windGust   = "wind_gust"
        case weather
    }
}



// MARK: - Daily
struct Daily: Codable {
    let dt, sunrise, sunset, moonrise:  Int
    let moonset:                        Int
    let moonPhase:                      Double
    let temp:                           Temp
    let feelsLike:                      FeelsLike
    let pressure, humidity:             Int
    let dewPoint, windSpeed:            Double
    let windDeg:                        Int
    let windGust:                       Double
    let weather:                        [Weather]
    let clouds:                         Int
    let pop:                            Double
    let snow:                           Double?
    let uvi:                            Double

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, moonrise, moonset
        case moonPhase  = "moon_phase"
        case temp
        case feelsLike  = "feels_like"
        case pressure, humidity
        case dewPoint   = "dew_point"
        case windSpeed  = "wind_speed"
        case windDeg    = "wind_deg"
        case windGust   = "wind_gust"
        case weather, clouds, pop, snow, uvi
    }
}

// MARK: - FeelsLike
struct FeelsLike: Codable {
    let day, night, eve, morn: Double
}

// MARK: - Temp
struct Temp: Codable {
    let day, min, max, night:   Double
    let eve, morn:              Double
}
