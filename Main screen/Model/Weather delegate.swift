//
//  weather delegate.swift
//  my weather
//
//  Created by Никита Денисов on 10.03.2022.
//

import Foundation

protocol WeatherDelegate {
    func setTitle(temp: Int)
    func setWeatherDescription(description: String)
    func setWeatherImage(with name: String)
    func setCityName(with name: String)
    func reloadBottomOptions()
    func reloadForecastCollection()
}
