//
//  CustomWeekCell.swift
//  my weather
//
//  Created by Никита Денисов on 24.03.2022.
//

import Foundation
import UIKit

class CustomTableCell: UITableViewCell {
    var data: CustomCell? {
            didSet {
                guard let data  = data else {return}
                dayOfTheWeek.text   = data.dayOfTheWeek
                image.image         = UIImage(named: "day" + data.image!)
                desc.text           = data.description
                maxTemp.text        = data.maxTemp
                minTemp.text        = data.minTemp
            }
        }
    
    var dayOfTheWeek: UILabel = {
        let label                                       = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font                                      = UIFont(name: "HelveticaNeue-Bold", size: 17)
        label.textColor                                 = UIColor(red: 158/255, green: 219/255, blue: 255/255, alpha: 0.54)
        return label
    }()
    
    var image: UIImageView = {
        let imageView                                       = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "calendar")
        imageView.contentMode                               = .scaleAspectFit
        return imageView
    }()
    
    var desc: UILabel = {
        let label                                       = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font                                      = UIFont(name: "HelveticaNeue-Bold", size: 17)
        label.text                                      = "desc"
        label.textColor                                 = UIColor(red: 158/255, green: 219/255, blue: 255/255, alpha: 0.54)
        return label
    }()
    
    var maxTemp: UILabel = {
        let label                                       = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font                                      = UIFont(name: "HelveticaNeue-Bold", size: 20)
        label.textColor                                 = .black
        label.textAlignment                             = .left
        label.textColor                                 = .white
        return label
    }()
    
    var minTemp: UILabel = {
        let label                                       = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font                                      = UIFont(name: "HelveticaNeue-Bold", size: 20)
        label.textColor                                 = .black
        label.textAlignment                             = .right
        label.textColor                                 = UIColor(red: 158/255, green: 219/255, blue: 255/255, alpha: 0.54)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(dayOfTheWeek)
        contentView.addSubview(image)
        contentView.addSubview(desc)
        contentView.addSubview(maxTemp)
        contentView.addSubview(minTemp)
        
        //contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 100, left: 10, bottom: 100, right: 10))
        
        dayOfTheWeek.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive                  = true
        dayOfTheWeek.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25).isActive    = true
        
        image.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive                         = true
        image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 95).isActive           = true
        image.heightAnchor.constraint(equalToConstant: 40).isActive                                         = true
        image.widthAnchor.constraint(equalToConstant: 40).isActive                                          = true
        
        desc.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive                          = true
        desc.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 5).isActive                  = true
        
        minTemp.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive                       = true
        minTemp.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40).isActive      = true
        minTemp.widthAnchor.constraint(equalToConstant: 50).isActive                                        = true
        
        maxTemp.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive                       = true
        maxTemp.leadingAnchor.constraint(equalTo: minTemp.leadingAnchor, constant: -35).isActive            = true
    }
    required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
}

struct CustomCell {
    var dayOfTheWeek:   String?
    var image:          String?
    var description:    String?
    var maxTemp:        String?
    var minTemp:        String?
}
