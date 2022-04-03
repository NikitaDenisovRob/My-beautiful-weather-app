//
//  BottomOptions.swift
//  my weather
//
//  Created by Никита Денисов on 14.03.2022.
//

import Foundation
import UIKit

struct BottomOptions {
    var humImage: String?
    var optionsArray: [BottomWidget] = []
    
    init() {
        if #available(iOS 15, *) {
            self.humImage = "humidity.fill"
        } else {
            self.humImage = "drop"
        }
        
        optionsArray = [
            BottomWidget(image: UIImage(systemName: "wind"), description: "", name: ""),
            BottomWidget(image: UIImage(systemName: humImage!), description: "", name: ""),
            BottomWidget(image: UIImage(systemName: "sun.min"), description: "", name: "")
        ]
    }
    
    mutating func changeDescription(wind: String, humidity: String, feelings: String) {
        optionsArray[0].description = wind
        optionsArray[1].description = humidity
        optionsArray[2].description = feelings
    }
    
    mutating func changeName(wind: String, humidity: String, feelings: String) {
        optionsArray[0].name = wind
        optionsArray[1].name = humidity
        optionsArray[2].name = feelings
    }
    
}

struct BottomWidget {
    var image: UIImage?
    var description: String = ""
    var name: String        = ""
}
