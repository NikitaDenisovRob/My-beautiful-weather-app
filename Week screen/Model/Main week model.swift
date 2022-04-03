//
//  Main model.swift
//  my weather
//
//  Created by Никита Денисов on 24.03.2022.
//

import Foundation

class MainWeekModel {      
    internal let networkModel       = WeekNetworkModel()
    internal var bottomOptions      = BottomOptions()
    internal var delegate:          MainWeekDelegate?
    internal var dayliweather       = DayliWeather()
    internal var language:          Int?
    
    
    init() {
        networkModel.delegate = self
        networkModel.delegate = self
        
    }
    
    func fetchData(lat: Double, lon: Double) {
        let roundedLat = round(lat * 10) / 10
        let roundedLon = round(lon * 10) / 10
        networkModel.loadDataFromServer(lat: roundedLat, lon: roundedLon, with: language!)
    }
    
    private func translateToCelsium(value: Double) -> String {
        return String(Int(value - 273.15))
    }
    
    func countOfWeekList() -> Int {
        if let model = networkModel.pulledData {
            return model.daily.count - 2
        }else {
            return 0
        }
    }
    
    private func setData() {
        if let model = networkModel.pulledData {
            for day in model.daily[2...] {
                var dayliModel = CustomCell()
                //variables
                let min                 = translateToCelsium(value: day.temp.min) + "°"
                let max                 = translateToCelsium(value: day.temp.max) + "°"
                
                dayliModel.description  = mainDesck(current: day.weather[0].main) 
                dayliModel.maxTemp      = max.hasPrefix("-") ? max : "+" + max
                dayliModel.minTemp      = min.hasPrefix("-") ? min : "+" + min
                dayliModel.dayOfTheWeek = self.language == 1 ? fromUnixToNormalTimeEn(unix: TimeInterval(day.dt)) :
                                                                fromUnixToNormalTime(unix: TimeInterval(day.dt))
                dayliModel.image        = day.weather[0].main
                dayliweather.weatherArray.append(dayliModel)
            }
        }
    }
    
    private func mainDesck(current: String) -> String {
        if language == 1 {
            return current
        } else {
            switch current {
            case "Thunderstorm":
                return "Гроза"
            case "Drizzle":
                return "Дождь"
            case "Rain":
                return "Ливень"
            case "Snow":
                return "Снег"
            case "Clear":
                return "Ясно"
            case "Clouds":
                return "Пасмурно"
            default:
                return "Туман"
            }
        }
    }
    
    private func fromUnixToNormalTime(unix value: TimeInterval) -> String {
        let date = NSDate(timeIntervalSince1970: value)
        let calendar        = Calendar.current
        
        switch calendar.component(.weekday, from: date as Date) {
        case 1:
            return "Вс"
        case 2:
            return "Пн"
        case 3:
            return "Вт"
        case 4:
            return "Ср"
        case 5:
            return "Чт"
        case 6:
            return "Пт"
        case 7:
            return "Сб"
        default:
            return ""
        }
    }
    
    private func fromUnixToNormalTimeEn(unix value: TimeInterval) -> String {
        let date = NSDate(timeIntervalSince1970: value)
        let calendar        = Calendar.current
        
        switch calendar.component(.weekday, from: date as Date) {
        case 1:
            return "Sun"
        case 2:
            return "Mon"
        case 3:
            return "Tue"
        case 4:
            return "Wed"
        case 5:
            return "Thu"
        case 6:
            return "Fri"
        case 7:
            return "Sat"
        default:
            return ""
        }
    }
    
}

extension MainWeekModel: NetworkWeekDelegate {
    
    func setBottomOptions() {
        if let data = networkModel.pulledData {
            //for bottom options
            let wind        = String(Int(data.daily[1].windSpeed)) + (language == 1 ? " m/s" : " м/сек")
            let humidity    = String(data.daily[1].humidity) + "%"
            let feelsLike   = translateToCelsium(value: data.daily[1].feelsLike.day) + "°"
            //for mainTemp
            let mainTemp    = translateToCelsium(value: data.daily[1].temp.max)
            let minTemp     = translateToCelsium(value: data.daily[1].temp.min)
            //desc
            let weatherDesc = data.daily[1].weather[0].weatherDescription
            let picture     = data.daily[1].weather[0].main
            bottomOptions.changeDescription(wind: wind, humidity: humidity, feelings: feelsLike)
            if language! == 1 {
                bottomOptions.changeName(wind: "Wind", humidity: "Humidity", feelings: "Feels like")
            } else {
                bottomOptions.changeName(wind: "Ветер", humidity: "Влажность", feelings: "Ощущается как")
            }
            setData()
            DispatchQueue.main.async { [weak self] in
                self!.delegate?.updateBottom()
                self!.delegate?.setMainTemperature(temp: mainTemp)
                self!.delegate?.setSecondTemperature(temp: minTemp)
                self!.delegate?.setDescription(desc: weatherDesc)
                self!.delegate?.setImage(desc: picture)
                self!.delegate?.updateTableView()
            }
        }
    }
}
