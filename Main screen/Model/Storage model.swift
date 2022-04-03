//
//  Storage model.swift
//  my weather
//
//  Created by Никита Денисов on 11.03.2022.
//

import Foundation

struct Storage {
    private let storageDefault      = UserDefaults.standard
    private let lastTemperature     = "Temperature"

// language 0 is russian, 1 is engleash
    private let language            = "language"
    
    func setValue(value: Int) {
        storageDefault.set(value, forKey: lastTemperature)
    }
    
    func getLastTemperature() -> Int {
        return storageDefault.integer(forKey: lastTemperature)
    }
    
    func getLanguage() -> Int {
        return storageDefault.integer(forKey: language)
    }
    
    func setLanguage(value: Int) {
        storageDefault.set(value, forKey: language)
    }
}
