//
//  ForecastCustomCell.swift
//  my weather
//
//  Created by Никита Денисов on 16.03.2022.
//

import Foundation
import UIKit

class ForecastCustomCell: UICollectionViewCell {
    var data: ForecastCollection? {
            didSet {
                guard let data  = data else {return}
                image.image = data.image
                temperatureText.text = data.temperature
                timeText.text = data.time
            }
        }
    let background: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
     
    private let temperatureText: UILabel = {
        let label                                       = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor                                 = .white
        label.font                                      = UIFont(name: "HelveticaNeue-Bold", size: 17)
        label.textAlignment                             = .center
        label.backgroundColor = .clear
        return label
    }()
    
    private let image: UIImageView = {
        let view                                        = UIImageView()
        view.contentMode                                = .scaleAspectFit
        view.tintColor                                  = .white
        view.translatesAutoresizingMaskIntoConstraints  = false
        view.backgroundColor                            = .clear
        return view
    }()
        
    private let timeText: UILabel = {
        let label                                       = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor                                 = UIColor(red: 158/255, green: 219/255, blue: 255/255, alpha:                                                                                                   0.54)
        label.font                                      = UIFont(name: "HelveticaNeue-Bold", size: 12)
        label.textAlignment                             = .center
        label.backgroundColor = .clear
        return label
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(background)
        contentView.addSubview(temperatureText)
        contentView.addSubview(image)
        contentView.addSubview(timeText)
        
        background.frame = contentView.bounds
        
        temperatureText.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive         = true
        temperatureText.bottomAnchor.constraint(equalTo: temperatureText.topAnchor, constant: 14).isActive  = true
        temperatureText.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive               = true
        
        image.topAnchor.constraint(equalTo: temperatureText.bottomAnchor, constant: 6).isActive             = true
        image.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive                         = true
        image.heightAnchor.constraint(equalToConstant: 35).isActive                                         = true
        image.widthAnchor.constraint(equalTo: image.heightAnchor).isActive                                  = true
        
        timeText.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 5).isActive                    = true
        timeText.heightAnchor.constraint(equalToConstant: 10).isActive = true
        timeText.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive                      = true
    }
    required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
}
