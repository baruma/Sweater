//
//  ViewController.swift
//  Sweater
//
//  Created by Liana Haque on 12/2/20.
//

import UIKit
import CoreLocation

class WeatherDisplayVC: UIViewController {
    let weatherResponseRepository = WeatherResponseRepository()
    let controller = WeatherDisplayController()
    let sweatCache = SweatCache()

    let locationManager = CLLocationManager()

    var collectionView: UICollectionView!
    let searchBar = UISearchBar()
    
    var readableLocation: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureLocationManagerServices()
        configureCollectionView()
        NotificationCenter.default.addObserver(self, selector: #selector(self.appResume), name: UIApplication.willEnterForegroundNotification, object: nil)
        configureSearchBar()
}
    
    @objc func appResume() {
        collectionView.reloadData()
    }
    
    func configureSearchBar() {
        let rightBarButtonItem = UIBarButtonItem(customView: searchBar)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationController?.navigationBar.prefersLargeTitles = true
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.showsCancelButton = true
        searchBar.tintColor = .systemPink
    }
    
    func configureNavigationBarDateAndLocation() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        let dateResult = formatter.string(from: date)
        let dateAndLocation = dateResult + readableLocation
        self.title = dateAndLocation
    }
    
    func configureLocationManagerServices() {
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer

        // You are unable to use locationManager here due to a scoping issue. This is specific to Swift.
        if CLLocationManager.locationServicesEnabled() {
            /// There is a frequency to monitoring for location changes.  This is being used so locationManager isn't constantly being called.
            locationManager.startMonitoringSignificantLocationChanges()
            print("Locationmanager has been hit")
        }
    }
    
    func convertCoordinatesToReadableLocation() {
        let geoCoder = CLGeocoder()
        let latitude = CLLocationDegrees(controller.latitude)
        let longitude = CLLocationDegrees(controller.longitude)
        let location = CLLocation(latitude: latitude, longitude: longitude)

        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in

             // Place details
            guard let placeMark = placemarks?.first else { return }

            // Location name
            if let locationName = placeMark.location {
                print(locationName)
            }
            // City
            if var city = placeMark.subAdministrativeArea {
                print(city)
                self.readableLocation = city
            }
            // Zip code
            if let zip = placeMark.isoCountryCode {
                print(zip)
            }
            // Country
            if let country = placeMark.country {
                print(country)
            }
        }
    }

    func configureCollectionView() {
        //let layout = UICollectionViewFlowLayout()
        //layout.itemSize = CGSize(width: 100, height: 100)
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
        collectionView.backgroundColor = .black
        view.addSubview(collectionView)
        collectionView.register(SweatTemperatureCell.self, forCellWithReuseIdentifier: SweatTemperatureCell.reuseID)
        collectionView.register(SweatWeatherDetailInformationCell.self, forCellWithReuseIdentifier: SweatWeatherDetailInformationCell.reuseID)
        collectionView.register(SweatWeatherDescriptionCell.self, forCellWithReuseIdentifier: SweatWeatherDescriptionCell.reuseID)
        collectionView.register(SweatHourlyWeatherCell.self, forCellWithReuseIdentifier: SweatHourlyWeatherCell.reuseID)
        collectionView.register(SweatHourlyWeatherCell.self, forCellWithReuseIdentifier: SweatHourlyWeatherCell.reuseID)
        collectionView.register(SweatWeeklyWeatherCell.self, forCellWithReuseIdentifier: SweatWeeklyWeatherCell.reuseID)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    func generateLayout() -> UICollectionViewLayout {
        /// The items below will be dropped into their corresponding groups.
        /// Displays current temperature, and min and max temperatures for the day.
        ///
        /// The temperature Item is a single custom cell that displays the primary current temperature, and the min and max tempratures of the day.
        let temperatureItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.70)))
        
        /// Displays weather detail information (Humidity, Precipitation, UVI, Cloudiness.  These are prone to change depending on user preference).
        let detailWeatherInformationItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1/3)))
        
        // so we declared the description group and how it will be laid out.
        let weatherDescriptionItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)))
        
        let hourlyWeatherItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(0.3)))
        
        let weeklyWeatherItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth((0.3))))
        
        /// The groups that will be holding the items declared earlier.
        let temperatureInformationGroup = NSCollectionLayoutGroup.vertical(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.70),
            heightDimension: .fractionalHeight(1.0)),
            subitem: temperatureItem, count: 1)
        
        let detailWeatherInformationGroup = NSCollectionLayoutGroup.vertical(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.30),
            heightDimension: .fractionalHeight(1.0)),
            subitem: detailWeatherInformationItem, count: 3)
        
        let weatherDescriptionGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(0.3)),
                subitem: weatherDescriptionItem, count: 1)
        
        let hourlyWeatherGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.3)),
                subitem: hourlyWeatherItem, count: 1)
        
        let weeklyWeatherGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.7)),
                subitem: weeklyWeatherItem, count: 1)
        
        /// The nested group holds onto all of the groups declared earlier.
        let horizontalParentGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1/3)),
                subitems: [temperatureInformationGroup, detailWeatherInformationGroup])
        
        let hourlyAndWeeklyGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.5)),
            subitems: [hourlyWeatherGroup, weeklyWeatherGroup])

        let verticalParentGroup = NSCollectionLayoutGroup.vertical(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)),
            subitems: [horizontalParentGroup, weatherDescriptionGroup, hourlyAndWeeklyGroup])
        
        let section = NSCollectionLayoutSection(group: verticalParentGroup)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}

extension WeatherDisplayVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation: CLLocation = locations[0]
        let lat = Float(currentLocation.coordinate.latitude)
        let lon = Float(currentLocation.coordinate.longitude)
        controller.saveAndUpdateCoordinates(latitude: lat, longitude: lon)
       // weatherResponseRepository.fetchWeather(latitude: lat, longitude: lon)
        convertCoordinatesToReadableLocation()
        configureNavigationBarDateAndLocation()
        collectionView.reloadData()
    }

    /// Self explanatory, failing with error if user does not allow app to retrive location.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // - TODO: Create an alert VC for user if location is not able to be fetched.
        print("Unable to fetch location")
    }
}

extension WeatherDisplayVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // must update this number.  You may need to make a switch case
        return 7
    }
    
    /// The Layout was built this way to incorporate the various types of cells the View woudld be using.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("Section \(indexPath.section) Row \(indexPath.row) Index \(indexPath.item)")
            
        switch indexPath.section {
        case 0:
            switch indexPath.item {
            case 0:
                let primaryCell = collectionView.dequeueReusableCell(withReuseIdentifier: SweatTemperatureCell.reuseID, for: indexPath) as! SweatTemperatureCell
               // controller.getMainTemperature(listener: primaryCell)  // this is where you put your support request in and give your number for the service to call you back on.
                controller.getMainTemp().done { temperature in primaryCell.onDataReceived(temp: temperature)}
                return primaryCell
            case 1:
                let tertiaryCell = collectionView.dequeueReusableCell(withReuseIdentifier: SweatWeatherDetailInformationCell.reuseID, for: indexPath) as! SweatWeatherDetailInformationCell
                controller.getFeelsLikeTemperatureDetail().done { temperature in tertiaryCell.onDataReceived(weatherDetail: String(temperature.feelsLike))}
                return tertiaryCell
            case 2:
                let tertiaryCell = collectionView.dequeueReusableCell(withReuseIdentifier: SweatWeatherDetailInformationCell.reuseID, for: indexPath) as! SweatWeatherDetailInformationCell
                controller.getHumidityDetail().done { weatherDetail in tertiaryCell.onDataReceived(weatherDetail: String(weatherDetail.humidity))}
                //controller.getHumidityDetail(listener: tertiaryCell)
                return tertiaryCell
            case 3:
                let tertiaryCell = collectionView.dequeueReusableCell(withReuseIdentifier: SweatWeatherDetailInformationCell.reuseID, for: indexPath) as! SweatWeatherDetailInformationCell
                controller.getPrecipitationDetail().done { weatherDetail in tertiaryCell.onDataReceived(weatherDetail: String(weatherDetail.precipitation))}
                return tertiaryCell
            case 4:
                let weatherDescriptionCell = collectionView.dequeueReusableCell(withReuseIdentifier: SweatWeatherDescriptionCell.reuseID, for: indexPath) as!
                    SweatWeatherDescriptionCell
                controller.getWeatherDescription().done { weatherDescriptionAggregate in weatherDescriptionCell.onDataReceived(weatherDescription: weatherDescriptionAggregate)}
                return weatherDescriptionCell
            case 5:
                let hourlyWeatherCell = collectionView.dequeueReusableCell(withReuseIdentifier: SweatHourlyWeatherCell.reuseID, for: indexPath) as!
                    SweatHourlyWeatherCell
               // controller.getHourlyWeather().done { hourlyWeather in hourlyWeather}
                controller.getHourlyWeather().done { hourlyWeather in hourlyWeatherCell.onDataReceived(hourlyWeather: hourlyWeather)}
                return hourlyWeatherCell
            case 6:
                let weeklyWeatherCell = collectionView.dequeueReusableCell(withReuseIdentifier: SweatWeeklyWeatherCell.reuseID, for: indexPath) as!
                    SweatWeeklyWeatherCell
               // controller.getWeeklyWeather(listener: weeklyWeatherCell)
                controller.getWeeklyWeather().done {weeklyWeather in weeklyWeatherCell.onDataReceived(weeklyWeather: weeklyWeather)}
                return weeklyWeatherCell
            
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SweatTemperatureCell.reuseID, for: indexPath) as! SweatTemperatureCell
                return cell
            }
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SweatTemperatureCell.reuseID, for: indexPath) as! SweatTemperatureCell
             return cell
        }
    }
}

extension WeatherDisplayVC: UICollectionViewDelegate {}

extension WeatherDisplayVC: UISearchBarDelegate {
    
}
