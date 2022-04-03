//
//  Network Delegate.swift
//  my weather
//
//  Created by Никита Денисов on 24.03.2022.
//

import Foundation

protocol NetworkWeekDelegate {
    func setBottomOptions()
}

protocol MainWeekDelegate {
    func updateBottom()
    func setMainTemperature(temp: String)
    func setSecondTemperature(temp: String)
    func setImage(desc: String)
    func setDescription(desc: String)
    func updateTableView()
}
