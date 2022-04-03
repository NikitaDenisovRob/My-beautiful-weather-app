//
//  WeekViewController.swift
//  my weather
//
//  Created by Никита Денисов on 23.03.2022.
//

import UIKit

class WeekViewController: UIViewController {
    
    internal var latitude:          Double?
    internal var longtitude:        Double?
    private let model               = MainWeekModel()
    
    // MARK: - View
    
    private let gradientForSubstrate: CAGradientLayer = {
        let gradient            = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 0.00, green: 0.81, blue: 0.96, alpha: 1).cgColor,
            UIColor(red: 0.02, green: 0.36, blue: 0.91, alpha: 1).cgColor
        ]
        gradient.startPoint     = CGPoint(x: 0.5, y: 0)
        gradient.endPoint       = CGPoint(x: 0.5, y: 1)
        return gradient
    }()
    
    private let backgroundView: UIView = {
        let view                                        = UIView()
        view.translatesAutoresizingMaskIntoConstraints  = false
        view.layer.cornerRadius                         = 70
        view.backgroundColor                            = UIColor(red: 3/255, green: 55/255, blue: 139/255, alpha: 1)
       
        view.layer.masksToBounds                        = false
        view.layer.shadowRadius                         = 40
        view.layer.shadowOpacity                        = 0.9
        view.layer.shadowColor                          = UIColor(red: 3/255, green: 55/255, blue: 139/255, alpha: 1).cgColor
        view.layer.shadowOffset                         = CGSize(width: 0 , height:40)
        return view
    }()
    
    private let substrate: UIView = {
        let view                                        = UIView()
        view.translatesAutoresizingMaskIntoConstraints  = false
        view.layer.cornerRadius                         = 70
        view.backgroundColor                            = .white
        view.layer.borderWidth                          = 2.5
        view.layer.borderColor                          = UIColor(red: 0.00, green: 0.91, blue: 0.96, alpha: 0.22).cgColor
        
        return view
    }()
    
    private let tableView: UITableView = {
        let table                                       = UITableView()
        table.backgroundColor                           = .clear
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle                            = .none
        table.allowsSelection                           = false
        return table
    }()
    
    private let fiveDaysLabe: UILabel = {
        let label                                       = UILabel()
        label.text                                      = "6 дней"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font                                      = UIFont(name: "HelveticaNeue-Bold", size: 26)
        label.textColor                                 = .white
        return label
    }()
    
    private let calendarImage: UIImageView = {
        let view                                        = UIImageView(frame: CGRect(x: 1, y: 1, width: 40, height: 40))
        view.backgroundColor                            = .clear
        view.translatesAutoresizingMaskIntoConstraints  = false
        view.image                                      = UIImage(named: "calendar")?.withTintColor(.white)
        return view
    }()
    
    private let weatherImage: UIImageView = {
        let view                                        = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints  = false
        view.backgroundColor = .clear
        view.contentMode                               = .scaleAspectFit
        view.layer.masksToBounds                       = false
        view.layer.shadowRadius                        = 25
        view.layer.shadowOpacity                       = 0.3
        view.layer.shadowColor                         = UIColor.black.cgColor
        view.layer.shadowOffset                        = CGSize(width: 25 , height:25)
        return view
    }()
    
    private let tomorowLabel: UILabel = {
        let label                                       = UILabel()
        label.text                                      = "Завтра"
        label.font                                      = UIFont(name: "HelveticaNeue-Bold", size: 24)
        label.textColor                                 = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let mainTempLabel: UILabel = {
        let label                                       = UILabel()
        label.text                                      = "_"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font                                      = UIFont(name: "HelveticaNeue-Bold", size: 100)
        label.textColor                                 = .white
        label.textAlignment                             = .left
        //label.backgroundColor                           = .black
        return label
    }()
    
    private let secondTempLabel: UILabel = {
        let label                                       = UILabel()
        label.text                                      = "/_°"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font                                      = UIFont(name: "HelveticaNeue-Bold", size: 50)
        label.textColor                                 = UIColor(red: 158/255, green: 219/255, blue: 255/255, alpha:                                                                                                             0.54)
        //label.backgroundColor = .red
        return label
    }()
    
    private let weatherDescription: UILabel = {
        let label                                       = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text                                      = "Облачно с прояснениями"
        label.font                                      = UIFont(name: "HelveticaNeue-Bold", size: 13)
        label.textColor                                 = UIColor(red: 158/255, green: 219/255, blue: 255/255, alpha:                                                                                                             0.54)
        return label
    }()
    
    private func setBackgroundForSubstrate() {
        self.substrate.layoutIfNeeded()
        self.substrate.layer.addSublayer(self.gradientForSubstrate)
        self.gradientForSubstrate.frame = self.substrate.bounds
        self.substrate.clipsToBounds    = true
    }
    
    private let line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints  = false
        view.backgroundColor                            = UIColor(red: 158/255, green: 219/255, blue: 255/255, alpha:                                                                                                             0.05)
        return view
    }()
    
    private let bottomOptions: UICollectionView = {
        let flowLayout                                              = UICollectionViewFlowLayout()
        flowLayout.itemSize                                         = CGSize(width: 70, height: 150)
        flowLayout.sectionInset                                     = UIEdgeInsets(top: 0, left: 32, bottom: 0, right:                                                                                                            35)
        flowLayout.minimumInteritemSpacing                          = 20
        
        let collectionView                                          = UICollectionView(frame: CGRect(x: 100, y: 100,                                                        width: 300, height: 200), collectionViewLayout: flowLayout)
        collectionView.backgroundColor                              = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints    = false
        collectionView.isScrollEnabled                              = false
        collectionView.register(BottomCustomCell.self, forCellWithReuseIdentifier: "BottomCell")
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private func setSecondFont() {
        if substrate.frame.width < 385 && secondTempLabel.text!.count <= 3{
            secondTempLabel.font    = UIFont(name: "HelveticaNeue-Bold", size: 30)
        } else if substrate.frame.width < 385 && secondTempLabel.text!.count > 3 {
            secondTempLabel.font    = UIFont(name: "HelveticaNeue-Bold", size: 20)
        } else {
            if mainTempLabel.text!.count == 3 && secondTempLabel.text!.count == 4 {
                secondTempLabel.font    = UIFont(name: "HelveticaNeue-Bold", size: 20)
            }
        }
    }
    
    private func makeConstrate() {
        
        substrate.topAnchor.constraint(equalTo: view.topAnchor).isActive                                            = true
        substrate.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive                                    = true
        substrate.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive                                  = true
        substrate.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 370).isActive                          = true
        
        backgroundView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -600).isActive                    = true
        backgroundView.bottomAnchor.constraint(equalTo: substrate.bottomAnchor, constant: 15).isActive             = true
        backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive              = true
        backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive                 = true
        
        tableView.topAnchor.constraint(equalTo: substrate.bottomAnchor, constant: 30).isActive                      = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive                  = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive                                    = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive                                  = true
        
        fiveDaysLabe.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25).isActive       = true
        fiveDaysLabe.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive                                 = true
        
        calendarImage.centerYAnchor.constraint(equalTo: fiveDaysLabe.centerYAnchor).isActive                        = true
        calendarImage.trailingAnchor.constraint(equalTo: fiveDaysLabe.leadingAnchor, constant: -7).isActive         = true
        calendarImage.heightAnchor.constraint(equalToConstant: 20).isActive                                         = true
        calendarImage.widthAnchor.constraint(equalTo: calendarImage.heightAnchor).isActive                          = true

        weatherImage.centerYAnchor.constraint(equalTo: substrate.centerYAnchor, constant: -20).isActive             = true
        weatherImage.leadingAnchor.constraint(equalTo: substrate.leadingAnchor, constant: 20).isActive              = true
        weatherImage.heightAnchor.constraint(equalToConstant: 130).isActive                                         = true
        weatherImage.widthAnchor.constraint(equalTo: weatherImage.heightAnchor).isActive                            = true
        
        //mainTempLabel.centerXAnchor.constraint(equalTo: tomorowLabel.centerXAnchor).isActive                      = true
        
        mainTempLabel.centerYAnchor.constraint(equalTo: weatherImage.centerYAnchor).isActive                        = true
        mainTempLabel.leadingAnchor.constraint(equalTo: weatherImage.trailingAnchor, constant: 20).isActive         = true
        mainTempLabel.heightAnchor.constraint(equalToConstant: 80).isActive                                         = true
        
        secondTempLabel.bottomAnchor.constraint(equalTo: mainTempLabel.bottomAnchor).isActive                       = true
        secondTempLabel.leadingAnchor.constraint(equalTo: mainTempLabel.trailingAnchor).isActive                    = true
        secondTempLabel.heightAnchor.constraint(equalToConstant: 40).isActive                                       = true
        
        tomorowLabel.bottomAnchor.constraint(equalTo: mainTempLabel.topAnchor, constant: -10).isActive               = true
        tomorowLabel.leadingAnchor.constraint(equalTo: weatherImage.trailingAnchor, constant: 20).isActive          = true
        
        weatherDescription.leadingAnchor.constraint(equalTo: tomorowLabel.leadingAnchor).isActive                   = true
        weatherDescription.topAnchor.constraint(equalTo: mainTempLabel.bottomAnchor, constant: 15).isActive         = true
        
        line.topAnchor.constraint(equalTo: weatherDescription.bottomAnchor, constant: 30).isActive                  = true
        line.heightAnchor.constraint(equalToConstant: 2).isActive                                                   = true
        line.leadingAnchor.constraint(equalTo: substrate.leadingAnchor, constant: 30).isActive                      = true
        line.trailingAnchor.constraint(equalTo: substrate.trailingAnchor, constant: -30).isActive                   = true
        
        bottomOptions.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 15).isActive                       = true
        bottomOptions.heightAnchor.constraint(equalToConstant: 70).isActive                                         = true
        bottomOptions.leadingAnchor.constraint(equalTo: substrate.leadingAnchor, constant: 20).isActive             = true
        bottomOptions.trailingAnchor.constraint(equalTo: substrate.trailingAnchor, constant: -20).isActive          = true
    }
    
    
    // MARK: - Life cycle
    override func loadView() {
        super.loadView()
        view.backgroundColor        = .black
        
        model.delegate              = self
        bottomOptions.delegate      = self
        bottomOptions.dataSource    = self
        tableView.delegate          = self
        tableView.dataSource        = self
        
        tableView.register(CustomTableCell.self, forCellReuseIdentifier: "Cell")
        
        model.fetchData(lat: latitude!, lon: longtitude!)
        
        view.layer.maskedCorners    = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.cornerRadius     = 70
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(backgroundView)
        view.addSubview(substrate)
        view.addSubview(tableView)
        view.addSubview(fiveDaysLabe)
        view.addSubview(calendarImage)
        view.addSubview(weatherImage)
        view.addSubview(tomorowLabel)
        view.addSubview(mainTempLabel)
        view.addSubview(secondTempLabel)
        view.addSubview(weatherDescription)
        view.addSubview(line)
        view.addSubview(bottomOptions)
        makeConstrate()
        setBackgroundForSubstrate()
        print("Size is \(substrate.frame.width)")
        
        setSecondFont()
        changeText()
    }
    
    
    

    // MARK: - View controller
    
    @objc func returnBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setLanguage(with lang: Int) {
        model.language = lang
    }
    
    private func changeText() {
        if model.language == 1 {
            fiveDaysLabe.text = "6 days"
            tomorowLabel.text = "Tomorrow"
        } else {
            fiveDaysLabe.text = "6 дней"
            tomorowLabel.text = "Завтра"
        }
    }

}

extension WeekViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BottomCell", for: indexPath) as! BottomCustomCell
        myCell.data = self.model.bottomOptions.optionsArray[indexPath.item]
        myCell.backgroundColor = .clear
        return myCell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.bottomOptions {
            return 3
        } else {
            return 0
        }
    }
    

}

extension WeekViewController: MainWeekDelegate {
    func updateBottom() {
        bottomOptions.reloadData()
    }
    
    func setMainTemperature(temp: String) {
        mainTempLabel.text = temp
    }
    
    func setSecondTemperature(temp: String) {
        secondTempLabel.text = "/" + temp + "°"
    }
    
    func setDescription(desc: String) {
        let stringArray = Array(desc)
        var firtsLetter = String(stringArray[0])
        firtsLetter = firtsLetter.uppercased()
        
        weatherDescription.text = firtsLetter + desc.dropFirst()
    }
    
    func setImage(desc: String) {
        let name = "day"
        weatherImage.image = UIImage(named: name + desc)
    }
    
    func updateTableView() {
        tableView.reloadData()
    }
}

extension WeekViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.countOfWeekList() - 1
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell            = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableCell
        cell.data           = model.dayliweather.weatherArray[indexPath.item]
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 5
    }
}

