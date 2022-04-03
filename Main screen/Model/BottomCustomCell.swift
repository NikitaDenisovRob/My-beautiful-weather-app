//
//  BottomCustomCell.swift
//  my weather
//
//  Created by Никита Денисов on 14.03.2022.
//

import UIKit

class BottomCustomCell: UICollectionViewCell {
    var data: BottomWidget? {
            didSet {
                guard let data  = data else {return}
                image.image     = data.image
                middleText.text = data.description
                bottomText.text = data.name
            }
        }
        private let image: UIImageView = {
            let view                                        = UIImageView()
            view.tintColor                                  = .white
            view.translatesAutoresizingMaskIntoConstraints  = false
            view.backgroundColor                            = .clear
            return view
        }()
        
        private let middleText: UILabel = {
            let label                                       = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor                                 = .white
            label.font                                      = UIFont(name: "HelveticaNeue-Bold", size: 14)
            label.textAlignment                             = .center
            label.backgroundColor = .clear
            return label
        }()
        
        private let bottomText: UILabel = {
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
            
            contentView.addSubview(image)
            contentView.addSubview(middleText)
            contentView.addSubview(bottomText)
            
            image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive                = true
            //image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25).isActive       = true
            //image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25).isActive    = true
            image.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive                     = true
            image.heightAnchor.constraint(equalToConstant: 20).isActive                                     = true
            image.widthAnchor.constraint(equalTo: image.heightAnchor).isActive                              = true
            
            middleText.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 8).isActive                  = true
            middleText.centerXAnchor.constraint(equalTo: image.centerXAnchor).isActive                          = true
            middleText.bottomAnchor.constraint(equalTo: middleText.topAnchor, constant: 13).isActive            = true
            
            bottomText.topAnchor.constraint(equalTo: middleText.bottomAnchor, constant: 2).isActive     = true
            bottomText.centerXAnchor.constraint(equalTo: image.centerXAnchor).isActive                  = true
            bottomText.heightAnchor.constraint(equalToConstant: 15).isActive                            = true
        }
        required init?(coder aDecoder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
}
