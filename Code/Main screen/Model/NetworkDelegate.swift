//
//  NetworkDelegate.swift
//  my weather
//
//  Created by Никита Денисов on 16.03.2022.
//

import Foundation

protocol NetworkDelegate {
    func updateDefaultAndSet()
    func updateForecast()
}
