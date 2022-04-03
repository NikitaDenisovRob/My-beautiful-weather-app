//
//  main model.swift
//  my weather
//
//  Created by Никита Денисов on 11.03.2022.
//

import MapKit
import CoreLocation
import Foundation

class MainModel {
    internal    var latitude:           Double?
    internal    var longtitude:         Double?
    internal    var delegate:           WeatherDelegate?
    internal    var bottomOptions       = BottomOptions()
    internal    var forecastCollection  = Forecast()
    private     let storage             = Storage()
    private     let networkModel        = NetworkModel()
    
    func getLastWeather() -> Int {
        setDelegate()
        return storage.getLastTemperature()
    }
    
    private func setDelegate() {
        networkModel.delegate = self
    }
    
    func saveCoordinates(lat: Double, long: Double) {
        self.latitude   = lat
        self.longtitude = long
    }
    
    func getCoordinates() -> (lat: Double, long: Double) {
        return (self.latitude!, self.longtitude!)
    }
    
    func updateTemperature() {
        let language = storage.getLanguage()
        if let lat = self.latitude,let long = self.longtitude {
            let roundedLat = round(lat * 10) / 10
            let roundedLon = round(long * 10) / 10
            
            networkModel.loadDataFromServer(lat: roundedLat, lon: roundedLon, with: language)
        }
        //networkModel.loadForecastFromServer(lat: roundedLat, lon: roundedLon)
    }
    
    func currentDate() -> String {
        let dateString:     String
        let date            = Date()
        let dateFormatter   = DateFormatter()
        let weekDay         = self.getCurrentLanguage() == 1 ? getWeekDayEn() : getWeekDay()
        
        dateFormatter.dateFormat = "dd MMMM"
        dateFormatter.locale = Locale(identifier: self.getCurrentLanguage() == 1 ? "en_US" :"ru_RU")
        dateString = dateFormatter.string(from: date as Date)
        
        return ("\(weekDay), \(dateString)")
    }
    
    func getForecastAttributes(index: Int) -> (weather: Int,
                                               desc: String) {
        let result =  networkModel.getForecastAttrebutes(index: index)
        setBottomOptions(windSpeed: result.wind, humidity: result.hum, feelsLike: result.feels)
        return (translateToCelsius(value: result.weather), result.desc)
    }
    
    func getCurrentLanguage() -> Int {
        let lang = storage.getLanguage()
        return lang
    }
    
    func setNewLang(_ value: Int) {
        storage.setLanguage(value: value)
    }
    
    private func translateToCelsius(value: Double) -> Int {
        return Int(value - 273.15)
    }
    
    private func getWeekDay() -> String {
        let calendar        = Calendar.current
        let date            = Date()
        
        switch calendar.component(.weekday, from: date) {
        case 1:
            return "Воскресенье"
        case 2:
            return "Понедельник"
        case 3:
            return "Вторник"
        case 4:
            return "Среда"
        case 5:
            return "Четверг"
        case 6:
            return "Пятница"
        case 7:
            return "Суббота"
        default:
            return ""
        }
    }
    
    private func getWeekDayEn() -> String {
        let calendar        = Calendar.current
        let date            = Date()
        
        switch calendar.component(.weekday, from: date) {
        case 1:
            return "Sunday"
        case 2:
            return "Monday"
        case 3:
            return "Monday"
        case 4:
            return "Wednesday"
        case 5:
            return "Thursday"
        case 6:
            return "Friday"
        case 7:
            return "saturday"
        default:
            return ""
        }
    }
    
    private func getCurrentTime() -> Int {
        let date                    = Date()
        let dateFormatter           = DateFormatter()
        dateFormatter.dateFormat    = "HH"
        dateFormatter.locale        = Locale(identifier: "ru_RU")

        let dateString              = dateFormatter.string(from: date as Date)
        let currentTime             = Int(dateString)!
        return currentTime
    }
    
    
    private func weatherImageName(time: Int, conditions: String) -> String {
        if time < 18 && time > 6 {
            return "day" + setDefaultImageName(condition: conditions)
        } else {
            return "night" + setDefaultImageName(condition: conditions)
        }
    }
    
    private func setDefaultImageName(condition: String) -> String {
        switch condition {
        case "Mist", "Smoke", "Haze", "Dust", "Fog", "Sand", "Ash", "Squall", "Tornado":
            return "Fog"
        default:
            return condition
        }
    }
    
    private func setBottomOptions(windSpeed: Double, humidity: Int, feelsLike: Double) {
        let lang    = storage.getLanguage()
        let speed   = String(Int(windSpeed)) + ((storage.getLanguage() == 1) ? " m/s": " м/сек")
        let hum     = String(humidity) + "%"
        let feeling = String(Int(translateToCelsius(value: feelsLike))) + "°"
        
        bottomOptions.changeDescription(wind: speed, humidity: hum, feelings: feeling)
        if lang == 1 {
            bottomOptions.changeName(wind: "Wind", humidity: "Humidity", feelings: "Feels like")
        } else {
            bottomOptions.changeName(wind: "Ветер", humidity: "Влажность", feelings: "Ощущается как")
        }
    }
    
    private func fromUnixToNormalTime(unix value: TimeInterval) -> String {
        let date                = NSDate(timeIntervalSince1970: value)
        let dateFormatter       = DateFormatter()
        
        dateFormatter.timeStyle = DateFormatter.Style.short//Set time style
        dateFormatter.dateStyle = DateFormatter.Style.none //Set date style
        dateFormatter.locale    = Locale(identifier: "ru_RU")
        dateFormatter.timeZone  = NSTimeZone() as TimeZone
        
        return dateFormatter.string(from: date as Date)
    }
    
    private func setForecast() {
        guard let forecast = networkModel.weatherForecast else {return}
        
        if storage.getLanguage() == 1 {
            forecastCollection.forecastArray[0].time = "Now"
        } else {
            forecastCollection.forecastArray[0].time = "Сейчас"
        }
        
        var timeArray: [String] = []
        var tempArray: [String] = []
        var imageArray: [String] = []
        
        for timeStemp in forecast.list[1..<4] {
            timeArray.append(fromUnixToNormalTime(unix: TimeInterval(timeStemp.dt)))
            tempArray.append(String(translateToCelsius(value: timeStemp.main.temp)) + "°")
            let timeInterval = fromUnixToNormalTime(unix: TimeInterval(timeStemp.dt))
            
            if timeInterval > "18:00" || timeInterval < "06:00" {
                imageArray.append("night" + timeStemp.weather[0].main)
            }else {
                imageArray.append("day" + timeStemp.weather[0].main)
            }
        }
        DispatchQueue.main.async {
            self.forecastCollection.setImage(imageNames: imageArray)
            self.forecastCollection.setTemperature(tempArray: tempArray)
            self.forecastCollection.setTime(timeArray: timeArray)
            self.delegate?.reloadForecastCollection()
        }
    }
}

extension MainModel: NetworkDelegate {
    func updateForecast() {
        setForecast()
    }
    
    func updateDefaultAndSet() {
        guard let information   = networkModel.mainInformation else {return}
        //variable for city name
        let cityName    = information.name
        //variables for temperature
        let celsium     = translateToCelsius(value: information.main.temp)
        let description = information.weather[0].weatherDescription
        //variables for weather image
        let currentTime = getCurrentTime()
        let condition   = information.weather[0].main
        let imageName   = weatherImageName(time: currentTime, conditions: condition)
        //variables for bottom options
        let windSpeed   = information.wind.speed
        let humidity    = information.main.humidity
        let feelings    = information.main.feelsLike
        setBottomOptions(windSpeed: windSpeed, humidity: humidity, feelsLike: feelings)
        storage.setValue(value: celsium)
        forecastCollection.forecastArray[0].temperature = String(celsium) + "°"
        forecastCollection.forecastArray[0].image = UIImage(named: imageName)

        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            strongSelf.delegate!.reloadBottomOptions()
            strongSelf.delegate!.setCityName(with: cityName)
            strongSelf.delegate!.setTitle(temp: celsium)
            strongSelf.delegate!.setWeatherDescription(description: description)
            strongSelf.delegate!.setWeatherImage(with: imageName)
        }
    }
}
