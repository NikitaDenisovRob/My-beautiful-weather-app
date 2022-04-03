//
//  ViewController.swift
//  my weather
//
//  Created by Никита Денисов on 09.03.2022.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    //weekViewController
    lazy var weekController        = WeekViewController()
    
    //location Manager
    lazy var locationManager    = CLLocationManager()
    
    //link to main model
    private var model           = MainModel()

    //MARK: - View
    
        //gradient for our main substrate
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
    
    private let gradientForForecast: CAGradientLayer = {
        let gradient            = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 0.00, green: 0.81, blue: 0.96, alpha: 1).cgColor,
            UIColor(red: 0.06, green: 0.4, blue: 0.95, alpha: 1).cgColor
        ]
        gradient.startPoint     = CGPoint(x: 0.5, y: 0)
        gradient.endPoint       = CGPoint(x: 0.5, y: 1)
        gradient.cornerRadius = 25
        return gradient
    }()
    
    private let backgroundView: UIView = {
        let view                                        = UIView()
        view.translatesAutoresizingMaskIntoConstraints  = false
        view.layer.cornerRadius                         = 70
        view.backgroundColor                            = UIColor(red: 3/255, green: 55/255, blue: 139/255, alpha: 1)
       
        view.layer.masksToBounds                       = false
        view.layer.shadowRadius                        = 40
        view.layer.shadowOpacity                       = 0.5
        view.layer.shadowColor                         = UIColor(red: 3/255, green: 55/255, blue: 139/255, alpha: 1).cgColor
        view.layer.shadowOffset                        = CGSize(width: 0 , height:40)
        return view
    }()
    
    private let substrate: UIView = {
        let view                                        = UIView()
        view.translatesAutoresizingMaskIntoConstraints  = false
        view.layer.cornerRadius                         = 70
        view.backgroundColor                            = .white
        view.layer.maskedCorners                        = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.layer.borderWidth                          = 2.5
        view.layer.borderColor                          = UIColor(red: 0.00, green: 0.91, blue: 0.96, alpha: 0.22).cgColor
        
        return view
    }()
    
    private let locationLabel: UILabel = {
        let label                                       = UILabel(frame: CGRect(x: 100, y: 100, width: 100, height: 20))
        label.backgroundColor                           = .clear
        label.text                                      = ""
        label.font                                      = UIFont(name: "HelveticaNeue-Bold", size: 26)
        label.textAlignment                             = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor                                 = .white
        return label
    }()
    
    private let locationImage: UIImageView = {
        let image                                       = UIImageView(frame: CGRect(x: 100, y: 100, width: 100, height:                                                                                                         20))
        image.image                                     = UIImage(named: "location")
        image.backgroundColor                           = .clear
        image.tintColor                                 = .white
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let weatherImage: UIImageView = {
        let imageView                                       = UIImageView()
        imageView.backgroundColor                           = .clear
        imageView.contentMode                               = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //shadow
        imageView.layer.masksToBounds                       = false
        imageView.layer.shadowRadius                        = 25
        imageView.layer.shadowOpacity                       = 0.3
        imageView.layer.shadowColor                         = UIColor.black.cgColor
        imageView.layer.shadowOffset                        = CGSize(width: 25 , height:25)
        return imageView
    }()
    
    private let temperature: UILabel = {
        let label                                       = UILabel(frame: CGRect(x: 200, y: 200, width: 100, height: 100))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor                           = .clear
        label.text                                      = ""
        label.textAlignment                             = .center
        label.textColor                                 = .white
        label.font                                      = UIFont(name: "HelveticaNeue-Bold", size: 160)
        /*
        label.layer.shadowColor                         = UIColor.white.cgColor
        label.layer.shadowOffset                        = .zero
        label.layer.shadowRadius                        = 1.5
        label.layer.shadowOpacity                       = 0.75
        label.layer.masksToBounds                       = false
        label.layer.shouldRasterize                     = true
         */
        return label
    }()
    
    private let weatherStatus: UILabel = {
        let label                                       = UILabel(frame: CGRect(x: 100, y: 100, width: 200, height: 20))
        label.text                                      = "_"
        label.font                                      = UIFont(name: "HelveticaNeue-Bold", size: 26)
        label.textColor                                 = .white
        label.textAlignment                             = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor                           = .clear
        return label
    }()
    
    private let date: UILabel = {
        let label                                       = UILabel(frame: CGRect(x: 100, y: 100, width: 100, height: 20))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor                           = .clear
        label.text                                      = "Понедельник"
        label.font                                      = UIFont(name: "HelveticaNeue-Bold", size: 13)
        label.textColor                                 = UIColor(red: 158/255, green: 219/255, blue: 255/255, alpha:                                                                                                             0.54)
        label.textAlignment                             = .center
        return label
    }()
    
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
        return collectionView
    }()
    
    private let todayLabel: UILabel = {
        let label                                       = UILabel()
        label.text                                      = "Сегодня"
        label.font                                      = UIFont(name: "HelveticaNeue-Bold", size: 20)
        label.backgroundColor                           = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor                                 = .white
        return label
    }()
    
    private let weekBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints   = false
        btn.setTitle("6 дней >", for: .normal)
        btn.setTitleColor(UIColor(red: 158/255, green: 219/255, blue: 255/255, alpha: 0.54), for: .normal)
        btn.backgroundColor                             = .clear
        btn.titleLabel?.font                            = UIFont(name: "HelveticaNeue-Bold", size: 13)
        btn.addTarget(self, action: #selector(swipeToweekController), for: .touchUpInside)
        return btn
    }()
    
    private let weatherForecastCollection: UICollectionView = {
        let flowLayout                                              = UICollectionViewFlowLayout()
        flowLayout.itemSize                                         = CGSize(width: 70, height: 95)
        flowLayout.sectionInset                                     = UIEdgeInsets(top: 0, left: 20, bottom: 0, right:                                                                                                            20)
        flowLayout.minimumInteritemSpacing                          = 5
        
        let collectionView                                          = UICollectionView(frame: CGRect(x: 100, y: 100,                                                        width: 300, height: 200), collectionViewLayout: flowLayout)
        collectionView.backgroundColor                              = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints    = false
        collectionView.isScrollEnabled                              = false
        collectionView.layer.masksToBounds                          = false
        collectionView.register(ForecastCustomCell.self, forCellWithReuseIdentifier: "ForecastCell")
        return collectionView
    }()
    
    private let languageBtn: UIButton = {
        let btn                                         = UIButton()
        btn.backgroundColor                             = .clear
        btn.addTarget(self, action: #selector(changeLang(_:)), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints   = false
        btn.layer.cornerRadius                          = 20
        btn.layer.borderWidth                           = 2
        btn.layer.borderColor                           = UIColor(red: 158/255, green: 219/255, blue: 255/255, alpha:                                                                                              0.54).cgColor
        btn.titleLabel?.font                            = UIFont(name: "HelveticaNeue-Bold", size: 15)
        return btn
    }()
    
    private func setBackgroundForSubstrate() {
        self.substrate.layoutIfNeeded()
        self.substrate.layer.addSublayer(self.gradientForSubstrate)
        self.gradientForSubstrate.frame = self.substrate.bounds
        self.substrate.clipsToBounds    = true
    }

    private func addConstrateForSubstrate() {
        backgroundView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -300).isActive        = true
        backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -165).isActive     = true
        backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive  = true
        backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive     = true
        
        substrate.topAnchor.constraint(equalTo: view.topAnchor).isActive                                = true
        substrate.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive                        = true
        substrate.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive                      = true
        substrate.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -175).isActive          = true
        
        weatherForecastCollection.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 45).isActive                                                                                                      = true
        weatherForecastCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 15).isActive                                                                                = true
        weatherForecastCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive                                                                                                           = true
        weatherForecastCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive                                                                                                        = true
    }
    
    private func addConstrateForTemp() {
        locationLabel.topAnchor.constraint(equalTo: substrate.safeAreaLayoutGuide.topAnchor, constant: 5).isActive                                                                                                           = true
        locationLabel.centerXAnchor.constraint(equalTo: substrate.centerXAnchor).isActive                   = true
        locationLabel.heightAnchor.constraint(equalToConstant: 30).isActive                                 = true
        
        locationImage.topAnchor.constraint(equalTo: locationLabel.topAnchor, constant: 5).isActive          = true
        locationImage.trailingAnchor.constraint(equalTo: locationLabel.leadingAnchor, constant:-2).isActive = true
        locationImage.bottomAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant:-5).isActive    = true
        locationImage.widthAnchor.constraint(equalTo: locationImage.heightAnchor, multiplier: 1.2).isActive                                                                                                                  = true
        
        languageBtn.centerYAnchor.constraint(equalTo: locationLabel.centerYAnchor).isActive                 = true
        //languageBtn.topAnchor.constraint(equalTo: locationLabel.topAnchor).isActive                         = true
        languageBtn.heightAnchor.constraint(equalToConstant: 40).isActive                                   = true
        languageBtn.widthAnchor.constraint(equalTo: languageBtn.heightAnchor).isActive                      = true
        languageBtn.leadingAnchor.constraint(equalTo: substrate.trailingAnchor, constant: -60).isActive     = true
        
        temperature.leadingAnchor.constraint(equalTo: substrate.leadingAnchor, constant: 20).isActive       = true
        temperature.trailingAnchor.constraint(equalTo: substrate.trailingAnchor, constant: -20).isActive    = true
        temperature.topAnchor.constraint(equalTo: substrate.bottomAnchor, constant: -320).isActive          = true
        temperature.bottomAnchor.constraint(equalTo: substrate.bottomAnchor, constant: -175).isActive       = true
        
        
        weatherImage.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 20).isActive       = true
        weatherImage.leadingAnchor.constraint(equalTo: substrate.leadingAnchor, constant: 20).isActive      = true
        weatherImage.trailingAnchor.constraint(equalTo: substrate.trailingAnchor, constant: -20).isActive   = true
        weatherImage.bottomAnchor.constraint(equalTo: temperature.topAnchor, constant: -5).isActive         = true
        
        weatherStatus.topAnchor.constraint(equalTo: temperature.bottomAnchor).isActive                      = true
        weatherStatus.leadingAnchor.constraint(equalTo: substrate.leadingAnchor, constant: 20).isActive     = true
        weatherStatus.trailingAnchor.constraint(equalTo: substrate.trailingAnchor, constant: -20).isActive  = true
        
        date.topAnchor.constraint(equalTo: weatherStatus.bottomAnchor, constant: 3).isActive                = true
        date.leadingAnchor.constraint(equalTo: substrate.leadingAnchor, constant: 40).isActive              = true
        date.trailingAnchor.constraint(equalTo: substrate.trailingAnchor, constant: -40).isActive           = true
        
        line.topAnchor.constraint(equalTo: date.bottomAnchor, constant: 22).isActive                        = true
        line.heightAnchor.constraint(equalToConstant: 2).isActive                                           = true
        line.leadingAnchor.constraint(equalTo: substrate.leadingAnchor, constant: 30).isActive              = true
        line.trailingAnchor.constraint(equalTo: substrate.trailingAnchor, constant: -30).isActive           = true
        
        bottomOptions.topAnchor.constraint(equalTo: date.bottomAnchor, constant: 35).isActive               = true
        bottomOptions.leadingAnchor.constraint(equalTo: substrate.leadingAnchor, constant: 20).isActive     = true
        bottomOptions.trailingAnchor.constraint(equalTo: substrate.trailingAnchor, constant: -20).isActive  = true
        bottomOptions.bottomAnchor.constraint(equalTo: substrate.bottomAnchor, constant: -20).isActive      = true
        
        todayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive             = true
        todayLabel.topAnchor.constraint(equalTo: substrate.bottomAnchor, constant: 15).isActive             = true
       
        weekBtn.centerYAnchor.constraint(equalTo: todayLabel.centerYAnchor).isActive                        = true
        weekBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive             = true
        weekBtn.heightAnchor.constraint(equalToConstant: 15).isActive                                       = true
        weekBtn.leadingAnchor.constraint(equalTo: weekBtn.trailingAnchor, constant: -80).isActive           = true
    }
 
    
    //MARK: - scene lifecycle
    
    override func loadView() {
        super.loadView()
        model.delegate                          = self
        bottomOptions.delegate                  = self
        bottomOptions.dataSource                = self
        weatherForecastCollection.delegate      = self
        weatherForecastCollection.dataSource    = self
        
        view.backgroundColor                    = .black
        setLastTemperature()
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: Notification.Name("sceneWillEnterForeground"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(backgroundView)
        view.addSubview(substrate)
        view.addSubview(weatherForecastCollection)
        addConstrateForSubstrate()
        setBackgroundForSubstrate()
        substrate.addSubview(locationLabel)
        substrate.addSubview(locationImage)
        substrate.addSubview(temperature)
        substrate.addSubview(date)
        substrate.addSubview(weatherImage)
        substrate.addSubview(line)
        substrate.addSubview(bottomOptions)
        substrate.addSubview(languageBtn)
        view.addSubview(todayLabel)
        view.addSubview(weekBtn)
        temperature.addSubview(weatherStatus)
        addConstrateForTemp()
        changeText()
    }
    
    //MARK: - View controller
    
    private func setLastTemperature() {
        let temp = model.getLastWeather()
        setTitle(temp: temp)
    }
    
    private func setDate() {
        let dataString = model.currentDate()
        self.date.text = dataString
    }
    
    private func changeText() {
        if model.getCurrentLanguage() == 1 {
            changeTextToEnglesh()
        } else {
            changeTextToRussian()
        }
    }
    
    private func changeTextToRussian() {
        todayLabel.text = "Сегодня"
        weekBtn.setTitle("6 дней >", for: .normal)
        languageBtn.setTitle("Ru", for: .normal)
    }
    
    private func changeTextToEnglesh() {
        todayLabel.text = "Today"
        weekBtn.setTitle("6 days >", for: .normal)
        languageBtn.setTitle("En", for: .normal)
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    //func to get api request when sceneWillEnterForeground
    @objc func willEnterForeground() {
        getCoordinates()
    }
    
    @objc func swipeToweekController(_ sender: UIButton) {
        let currentCoordinates      = model.getCoordinates()
        let language                = model.getCurrentLanguage()
        weekController.latitude     = currentCoordinates.lat
        weekController.longtitude   = currentCoordinates.long
        weekController.setLanguage(with: language)
        present(weekController, animated: true, completion: nil)
    }

}
//MARK: - View controller is delegate of main model. Is that okay or no?

extension ViewController: WeatherDelegate {
    func setTitle(temp: Int) {
        let stringTitle = String(temp)
        if stringTitle.count < 2 {
            self.temperature.text   = " " + stringTitle + "°"
        }else if stringTitle.count == 2 && stringTitle.hasPrefix("-") {
            self.temperature.text   = String(temp) + "°"
        }else if stringTitle.count == 3 {
            self.temperature.text   = String(temp) + "°"
        }else {
            self.temperature.text   = " " + stringTitle + "°"
        }
        setDate()
    }
    
    func setWeatherDescription(description: String) {
        let stringArray = Array(description)
        var firtsLetter = String(stringArray[0])
        firtsLetter = firtsLetter.uppercased()
        
        self.weatherStatus.text = firtsLetter + description.dropFirst()
    }
    
    func setWeatherImage(with name: String) {
        if let image = UIImage(named: name) {
            self.weatherImage.image = image
        }
    }
    
    func setCityName(with name: String) {
        self.locationLabel.text = name
    }
    
    func reloadBottomOptions() {
        bottomOptions.reloadData()
    }
    
    func reloadForecastCollection() {
        weatherForecastCollection.reloadData()
    }
    
    @objc func changeLang(_ sender: UIButton) {
        let currentLang = model.getCurrentLanguage()
        if currentLang == 1 {
            model.setNewLang(0)
            changeTextToRussian()
        } else {
            model.setNewLang(1)
            changeTextToEnglesh()
        }
        getCoordinates()
    }
}

//work with location manager
extension ViewController: CLLocationManagerDelegate {
    private func getCoordinates() {
               locationManager.requestWhenInUseAuthorization()
               if CLLocationManager.locationServicesEnabled() {
                   locationManager.delegate = self
                   locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
                   locationManager.startUpdatingLocation()
               }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        model.saveCoordinates(lat: locValue.latitude, long: locValue.longitude)
        model.updateTemperature()
        locationManager.stopUpdatingLocation()
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.bottomOptions {
            return 3
        } else {
            return 4
        }
    }

    
//This block is for customization cells when they only creating
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.bottomOptions {
            let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BottomCell", for: indexPath) as! BottomCustomCell
            myCell.data = self.model.bottomOptions.optionsArray[indexPath.item]
            myCell.backgroundColor = .clear
            return myCell
        } else {
            let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ForecastCell", for: indexPath) as! ForecastCustomCell
            myCell.data = self.model.forecastCollection.forecastArray[indexPath.item]
            if indexPath.row == 0 {
                makeFrame(cell: myCell)
                    
            } else {
                myCell.backgroundColor = .clear
                myCell.layer.borderWidth = 0.6
                myCell.layer.borderColor = UIColor(red: 0.00, green: 0.81, blue: 0.96, alpha: 0.2).cgColor
            }
            myCell.layer.cornerRadius = 25
            return myCell
        }
    }
    
//This block uses for customize cell when they were picked
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.weatherForecastCollection {
            if let cell = collectionView.cellForItem(at: indexPath) as? ForecastCustomCell {
                let currentTrueIndex = findCurrentForecast()
                if indexPath.row == 0 {
                    if indexPath.row == currentTrueIndex.row {
                        //pass
                    } else {
                        model.updateDefaultAndSet()
                        makeFrame(cell: cell)
                        let currentTrueCell = collectionView.cellForItem(at: currentTrueIndex) as? ForecastCustomCell
                        removeFrame(cell: currentTrueCell!)
                    }
                } else {
                    if indexPath.row != currentTrueIndex.row {
                        setFromForecast(index: indexPath.row)
                        weatherImage.image = cell.data?.image
                        makeFrame(cell: cell)
                        let currentTrueCell = collectionView.cellForItem(at: currentTrueIndex) as? ForecastCustomCell
                        removeFrame(cell: currentTrueCell!)
                    }
                }
            }
        }
    }
    
    func setFromForecast(index path: Int) {
        let atributes = model.getForecastAttributes(index: path)
        
        self.setTitle(temp: atributes.weather)
        self.setWeatherDescription(description: atributes.desc)
        self.bottomOptions.reloadData()
    }
    
    private func makeFrame(cell: ForecastCustomCell) {
        cell.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        cell.data?.isSelected = true
        //myCell.backgroundColor =  UIColor(red: 95/255, green: 166/255, blue: 251/255, alpha: 1)
        
        cell.background.layer.addSublayer(gradientForForecast)
        self.gradientForForecast.frame = cell.bounds
        cell.clipsToBounds = false
    
        cell.background.layer.shadowRadius                        = 8
        cell.background.layer.shadowOpacity                       = 0.6
        cell.background.layer.shadowColor                         = UIColor(red: 0.00, green: 0.81, blue: 0.96, alpha: 1).cgColor
        cell.background.layer.shadowOffset                        = CGSize(width: 0 , height:0)
        //weatherForecastCollection.reloadData()
    }
    
    private func removeFrame(cell: ForecastCustomCell) {
        cell.transform = CGAffineTransform(scaleX: 1, y: 1)
        cell.data?.isSelected = false
    }
    
    private func findCurrentForecast() -> IndexPath{
        for index in 0...3 {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = weatherForecastCollection.cellForItem(at: indexPath) as? ForecastCustomCell {
                if cell.data?.isSelected == true {
                    return indexPath
                }
            }
        }
        return IndexPath(row: -1, section: 0)
    }
}

