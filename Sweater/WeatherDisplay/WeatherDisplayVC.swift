//
//  ViewController.swift
//  Sweater
//
//  Created by Liana Haque on 12/2/20.
//

import UIKit
import CoreLocation
import PromiseKit

class WeatherDisplayVC: UIViewController, MVPView {
    
    typealias Presenter = WeatherDisplayPresenter
    
    let weatherResponseRepository = WeatherResponseRepository()
    let controller = WeatherDisplayPresenter()
    let sweatCache = SweatCache()

    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()

    var collectionView: UICollectionView!
    let searchBar = UISearchBar()
    
    var readableLocation: String = ""
    let address: String = ""
    
    enum Section: Int, CaseIterable {
        case currentTemp = 0
        case currentDescription = 1
        case forecast = 2
        case duskDawn = 3
    }

    let SectionItemCount: [Int] = [4,1,2,1]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureLocationManagerServices()
        configureCollectionView()
        NotificationCenter.default.addObserver(self, selector: #selector(self.appResume), name: UIApplication.willEnterForegroundNotification, object: nil)
        configureSearchBar()
        let testVoid =  convertReadableLocationToCoordinates(searchBarEntry: "1 Infinite Loop, Cupertino, CA 95014")
        print(testVoid)
        getPresenter().attach(view: self)
    }

    override func viewDidDisappear(_ animated: Bool) {
        getPresenter().detach()
    }

    @objc func appResume() {
        collectionView.reloadData()
    }
    
    func getPresenter() -> WeatherDisplayPresenter {
        return controller
    }
    
    func configureSearchBar() {
        let rightBarButtonItem = UIBarButtonItem(customView: searchBar)
        navigationController?.navigationBar.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.rightBarButtonItem = rightBarButtonItem

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
    
    /// This function exists to convert human readable place names into coordinates that can be passed into the network call.
    func convertReadableLocationToCoordinates(searchBarEntry: String) {
        geoCoder.geocodeAddressString(searchBarEntry) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
            else {
                // handle no location found
                print("Could not retrieve coordinates.")
                return
            }
            print(location)  // so we are getting the location. Now we have to do 2 things.  Put in SearchBar results in here and pass coordinates along.
        }
    }
    
    func convertCoordinatesToReadableLocation() {
       // let geoCoder = CLGeocoder()
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
    
    func generateLayout() -> UICollectionViewLayout {
          let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
              let sectionLayoutKind = Section.allCases[sectionIndex]
              switch (sectionLayoutKind) {
              case .currentTemp: return self.generateTemperatureSectionLayout()
              case .currentDescription: return self.generateCurrentWeatherDescriptionSectionLayout()
              case .forecast: return self.generateForecastSectionLayout()
              case .duskDawn: return self.generateDuskDawnSectionLayout()
              }
          }
          return layout
      }

    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
        collectionView.backgroundColor = .black
        view.addSubview(collectionView)
        collectionView.register(SweatTemperatureCell.self, forCellWithReuseIdentifier: SweatTemperatureCell.reuseID)
        collectionView.register(SweatWeatherDetailInformationCell.self, forCellWithReuseIdentifier: SweatWeatherDetailInformationCell.reuseID)
        collectionView.register(SweatWeatherDescriptionCell.self, forCellWithReuseIdentifier: SweatWeatherDescriptionCell.reuseID)
        collectionView.register(SweatHourlyWeatherCell.self, forCellWithReuseIdentifier: SweatHourlyWeatherCell.reuseID)
        collectionView.register(SweatHourlyWeatherCell.self, forCellWithReuseIdentifier: SweatHourlyWeatherCell.reuseID)
        collectionView.register(SweatWeeklyWeatherCell.self, forCellWithReuseIdentifier: SweatWeeklyWeatherCell.reuseID)
        collectionView.register(SweatDawnDuskCell.self, forCellWithReuseIdentifier: SweatDawnDuskCell.reuseID)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func generateTemperatureSectionLayout() -> NSCollectionLayoutSection {
        /// The temperature Item is a single custom cell that displays the primary current temperature, and the min and max tempratures of the day.
        let temperatureItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.70)))

        /// The groups that will be holding the items declared earlier.
        let temperatureGroup = NSCollectionLayoutGroup.vertical(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.70),
            heightDimension: .fractionalHeight(1.0)),
            subitem: temperatureItem, count: 1)
        
            let detailWeatherInformationItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1/3)))
    
            let detailWeatherInformationGroup = NSCollectionLayoutGroup.vertical(
              layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.30),
                heightDimension: .fractionalHeight(1.0)),
                subitem: detailWeatherInformationItem, count: 3)
        
        let combinedGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.3)),
                subitems: [temperatureGroup, detailWeatherInformationGroup])
        
        let section = NSCollectionLayoutSection(group: combinedGroup)
        return section
    }
    
    func generateCurrentWeatherDescriptionSectionLayout() -> NSCollectionLayoutSection {
        let weatherDescriptionItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)))
        let weatherDescriptionGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(0.3)),
            subitem: weatherDescriptionItem, count: 1)
        let section = NSCollectionLayoutSection(group: weatherDescriptionGroup)
        return section
    }
    
    func generateForecastSectionLayout() -> NSCollectionLayoutSection {
        let hourlyWeatherItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)))

        let hourlyWeatherGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.5)),
                subitem: hourlyWeatherItem, count: 1)

        let weeklyWeatherItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight((1.0))))

        let weeklyWeatherGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.5)),
                subitem: weeklyWeatherItem, count: 1)
        
        let combinedGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.3)),
                subitems: [hourlyWeatherGroup, weeklyWeatherGroup])
        
        let section = NSCollectionLayoutSection(group: combinedGroup)
        return section
    }
    
    func generateDuskDawnSectionLayout() -> NSCollectionLayoutSection {
        let duskDawnItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)))

        let duskDawnGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)),
            subitem: duskDawnItem, count: 1)

        let section = NSCollectionLayoutSection(group: duskDawnGroup)
        return section
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
        return SectionItemCount[section]
    }
    
    /// The Layout was built this way to incorporate the various types of cells the View woudld be using.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("Section \(indexPath.section) Row \(indexPath.row) Index \(indexPath.item)")
        
        // indexpath has both the section and the item
        switch indexPath.section {
        case Section.currentTemp.rawValue:
            switch indexPath.item {
            case 0:
                let primaryCell = collectionView.dequeueReusableCell(withReuseIdentifier: SweatTemperatureCell.reuseID, for: indexPath) as! SweatTemperatureCell
                configure(cell: primaryCell, fetchPromise: controller.getMainTemp())
                return primaryCell
                
            case 1:
                let tertiaryCell = collectionView.dequeueReusableCell(withReuseIdentifier: SweatWeatherDetailInformationCell.reuseID, for: indexPath) as! SweatWeatherDetailInformationCell
                configure(cell: tertiaryCell, fetchPromise: controller.getFeelsLikeTemperatureDetail()
                            .then{ temperature -> Promise<String> in
                                Promise.value(String(temperature.feelsLike))
                            }
                )
                return tertiaryCell
                
            case 2:
                let tertiaryCell = collectionView.dequeueReusableCell(withReuseIdentifier: SweatWeatherDetailInformationCell.reuseID, for: indexPath) as! SweatWeatherDetailInformationCell
                configure(cell: tertiaryCell, fetchPromise: controller.getHumidityDetail()
                            .then({ weatherDetail -> Promise<String> in
                                Promise.value(String(weatherDetail.humidity))
                            }))
                return tertiaryCell
                
            case 3:
                let tertiaryCell = collectionView.dequeueReusableCell(withReuseIdentifier: SweatWeatherDetailInformationCell.reuseID, for: indexPath) as! SweatWeatherDetailInformationCell
                configure(cell: tertiaryCell, fetchPromise: controller.getPrecipitationDetail().then({ weatherDetail -> Promise<String> in Promise.value(String(weatherDetail.precipitation))}))
                return tertiaryCell
                
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SweatTemperatureCell.reuseID, for: indexPath) as! SweatTemperatureCell
                return cell
            }
        case Section.currentDescription.rawValue:
            let weatherDescriptionCell = collectionView.dequeueReusableCell(withReuseIdentifier: SweatWeatherDescriptionCell.reuseID, for: indexPath) as!
                SweatWeatherDescriptionCell
            configure(cell: weatherDescriptionCell, fetchPromise: controller.getWeatherDescription())
            return weatherDescriptionCell
            
        case Section.forecast.rawValue:
            switch indexPath.item {
            case 0:
                let hourlyWeatherCell = collectionView.dequeueReusableCell(withReuseIdentifier: SweatHourlyWeatherCell.reuseID, for: indexPath) as!
                    SweatHourlyWeatherCell
                configure(cell: hourlyWeatherCell, fetchPromise: controller.getHourlyWeather())
                return hourlyWeatherCell
                
            case 1:
                let weeklyWeatherCell = collectionView.dequeueReusableCell(withReuseIdentifier: SweatWeeklyWeatherCell.reuseID, for: indexPath) as!
                    SweatWeeklyWeatherCell
                configure(cell: weeklyWeatherCell, fetchPromise: controller.getWeeklyWeather())
                return weeklyWeatherCell
                
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SweatTemperatureCell.reuseID, for: indexPath) as! SweatTemperatureCell
                return cell
            }
                
            case Section.duskDawn.rawValue:
                let duskAndDawnCell = collectionView.dequeueReusableCell(withReuseIdentifier: SweatDawnDuskCell.reuseID, for: indexPath) as!
                    SweatDawnDuskCell
                return duskAndDawnCell
                
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SweatTemperatureCell.reuseID, for: indexPath) as! SweatTemperatureCell
                return cell
            }

        
    }
    
    func configure<Cell : ConfigurableCell, ResultType>(cell: Cell, fetchPromise: Promise<ResultType>) {
        fetchPromise.done { result in
            cell.configure(data: result as! Cell.DataType)
        }.catch { error in
            print(error)
        }
    }
}

extension WeatherDisplayVC: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SectionItemCount.count
    }
}

extension WeatherDisplayVC: UISearchBarDelegate {}
