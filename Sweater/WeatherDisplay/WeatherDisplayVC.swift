//
//  ViewController.swift
//  Sweater
//
//  Created by Liana Haque on 12/2/20.
//

import UIKit
import CoreLocation
import PromiseKit

//JLI: General notes.  Removed unused code.  Have a path to display error cases
//JLI: Make sure there is a valid flow to show weather data when the user selects don't allow for location permission (finish search bar stuff)

class WeatherDisplayVC: UIViewController, CLLocationManagerDelegate, UISearchControllerDelegate, MVPView {
    
    typealias Presenter = WeatherDisplayPresenter
    
    private let weatherResponseRepository = WeatherResponseRepository()
    private let controller = WeatherDisplayPresenter()

    //JLI: Can you make a class that does geocoding for better reuse
    // and can you have the presenter call that class
    private let locationManager = CLLocationManager()
    private let geoCoderManager = GeoCoderManager()

    // JLI: Shouldn't need !
    private var collectionView: UICollectionView!
    private let gradientView = DarkTransparentGradientView()
    private var backgroundImageView = UIImageView()
    
    //JLI: might be moved if you refactor geocoding
    private var readableLocation: String = ""
    private let address: String = ""
        
    let locationResultVC = LocationResultTableViewVC()

    lazy var searchController = UISearchController(searchResultsController: locationResultVC)

    enum Section: Int, CaseIterable {
        case city = 0
        case currentTemp = 1 //0
        case currentDescription = 2 //1
        case forecast = 3 //2
        case duskDawn = 4 //3
        case supplementary =  5 //4
    }

    // add 1 up here for city label... remove 0 at left if things dont work with city label
    let SectionItemCount: [Int] = [1,4,1,2,1,1]

    override func viewDidLoad() {
        super.viewDidLoad()
        locationResultVC.locationResultListener = controller
        configureBackgroundImageViews()
        configureCollectionView()
        gradientView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        //JLI: move the next 4 lines to a method called "configureNavigationController"

        configureSearchController()
        configureLocationManagerServices()
        // You need to understand this - do somee research.  You're saying this is the observer.  
        NotificationCenter.default.addObserver(self, selector: #selector(self.appResume), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        getPresenter().attach(view: self)
    }
        
    func configureSearchController() {
        navigationItem.searchController = searchController
        navigationController?.navigationBar.backgroundColor         = .clear
        navigationController?.navigationBar.isTranslucent           = true
        navigationController?.navigationBar.tintColor               = .clear
        navigationController?.navigationBar.barTintColor            = .clear
        
        searchController.delegate                                   = self
        searchController.searchResultsUpdater                       = locationResultVC
        searchController.hidesNavigationBarDuringPresentation       = false
        searchController.automaticallyShowsScopeBar                 = false
        searchController.obscuresBackgroundDuringPresentation       = true
        searchController.automaticallyShowsSearchResultsController  = true
        searchController.searchBar.placeholder                      = "City, Country"
        searchController.searchBar.searchTextField.backgroundColor = .tertiaryLabel
        definesPresentationContext                                  = true
    }
    
    //JLI: move this out of a view controller
    func getCoordinateFrom(address: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> () ) {
        CLGeocoder().geocodeAddressString(address) {
            completion($0?.first?.location?.coordinate, $1)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        getPresenter().detach()
    }

    @objc func appResume() {
        collectionView.reloadData()
    }
    
    func refreshViewWithNewSearchData() {
        collectionView.reloadData()
    }
    
    func getPresenter() -> WeatherDisplayPresenter {
        return controller
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
    
    /// This converts human readable place names into coordinates that can be passed into the network call.
    func generateLayout() -> UICollectionViewLayout {
          let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
              let sectionLayoutKind = Section.allCases[sectionIndex]
              switch (sectionLayoutKind) {
              case .city: return self.generateCityCellSectionLayout()
              case .currentTemp: return self.generateTemperatureSectionLayout()
              case .currentDescription: return self.generateCurrentWeatherDescriptionSectionLayout()
              case .forecast: return self.generateForecastSectionLayout()
              case .duskDawn: return self.generateDuskDawnSectionLayout()
              case .supplementary: return self.generateSupplementaryInformationLayout()
              }
          }
          return layout
      }
    
    func configureBackgroundImageViews() {
        view.addSubview(backgroundImageView)
        
        let numberOfImages: UInt32 = 12
        let randomImage = arc4random_uniform(numberOfImages)
        let imageName = "image_\(randomImage)"
        backgroundImageView.image = UIImage(named: imageName)

        backgroundImageView.sizeToFit()
        backgroundImageView.clipsToBounds                             = true
        backgroundImageView.isOpaque                                  = true
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        //backgroundImageView.image                                     = UIImage(named: )

        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }

    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
        view.addSubview(collectionView)

        collectionView.backgroundColor = .clear
        collectionView.register(CityGreetingCell.self, forCellWithReuseIdentifier: CityGreetingCell.reuseID)
        collectionView.register(SweatTemperatureCell.self, forCellWithReuseIdentifier: SweatTemperatureCell.reuseID)
        collectionView.register(SweatWeatherDetailInformationCell.self, forCellWithReuseIdentifier: SweatWeatherDetailInformationCell.reuseID)
        collectionView.register(SweatWeatherDescriptionCell.self, forCellWithReuseIdentifier: SweatWeatherDescriptionCell.reuseID)
        collectionView.register(SweatHourlyWeatherCell.self, forCellWithReuseIdentifier: SweatHourlyWeatherCell.reuseID)
        collectionView.register(SweatHourlyWeatherCell.self, forCellWithReuseIdentifier: SweatHourlyWeatherCell.reuseID)
        collectionView.register(SweatWeeklyWeatherCell.self, forCellWithReuseIdentifier: SweatWeeklyWeatherCell.reuseID)
        collectionView.register(SweatDawnDuskCell.self, forCellWithReuseIdentifier: SweatDawnDuskCell.reuseID)
        collectionView.register(SweatSupplementaryInformationCell.self, forCellWithReuseIdentifier: SweatSupplementaryInformationCell.reuseID)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    func generateCityCellSectionLayout() -> NSCollectionLayoutSection {
        /// CityCell Item
        let cityCellItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)))
        
        /// CityCell Group
        let cityCellGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.05)),
            subitem: cityCellItem, count: 1)
        
        let section = NSCollectionLayoutSection(group: cityCellGroup)
        return section
    }
    
    func generateTemperatureSectionLayout() -> NSCollectionLayoutSection {
        /// The temperature Item is a single custom cell that displays the primary current temperature, and the min and max tempratures of the day.
        let temperatureItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.70)))

        /// The groups that will be holding the items declared above.
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
                heightDimension: .fractionalHeight(0.4)),
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
                heightDimension: .fractionalHeight(0.1)),
            subitem: duskDawnItem, count: 1)
        
        let section = NSCollectionLayoutSection(group: duskDawnGroup)
        return section
    }
    
    func generateSupplementaryInformationLayout() -> NSCollectionLayoutSection {
        let supplementaryInfoItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)))
        
        let supplementaryInfoGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.15)),
            subitem: supplementaryInfoItem, count: 1)
        
        let section = NSCollectionLayoutSection(group: supplementaryInfoGroup)
        return section
    }
}

extension WeatherDisplayVC {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let currentLocation: CLLocation = locations[0]
        let lat = Float(currentLocation.coordinate.latitude)
        let lon = Float(currentLocation.coordinate.longitude)
        controller.saveAndUpdateCoordinates(latitude: lat, longitude: lon)
        geoCoderManager.convertCoordinatesToHumanReadableLocation(location: currentLocation).done { placemark in
           let locationSearchResult =  LocationSearchResult.convertPlacemarkToLocationSearchResult(placemark: placemark)
            self.controller.onLocationResultUpdate(updatedLocation: locationSearchResult)
        }
        configureNavigationBarDateAndLocation()
    }

    /// Self explanatory, failing with error if user does not allow app to retrive location.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // - TODO: Create an alert VC for user if location is not able to be fetched.
        print("Unable to fetch location")
    }
}

extension WeatherDisplayVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SectionItemCount[section]
    }
    
    /// The Layout was built this way to incorporate the various types of cells the View woudld be using.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("Section \(indexPath.section) Row \(indexPath.row) Index \(indexPath.item)")
        
        
        
        switch indexPath.section {
        case Section.city.rawValue:            
                let cityCell = collectionView.dequeueReusableCell(withReuseIdentifier: CityGreetingCell.reuseID, for: indexPath) as! CityGreetingCell

            guard let locationSearchResult = controller.getCityName() else {
                print("oh snap")
                return cityCell
            }
            cityCell.updateCityNameAfterSearch(selectedPlacemark: locationSearchResult)
                return cityCell
 
        case Section.currentTemp.rawValue:
            switch indexPath.item {
            // represent these cases with something less hardcoded.  0 could be a constant like let  WeatherDescriptionCellIndex = 0
            //   and replace it with case WeatherDescriptionCellIndex

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
            configure(cell: duskAndDawnCell, fetchPromise: controller.getDuskDawn())
            return duskAndDawnCell
            
            
        case Section.supplementary.rawValue:
            let supplementaryCell = collectionView.dequeueReusableCell(withReuseIdentifier: SweatSupplementaryInformationCell.reuseID, for: indexPath) as!
                SweatSupplementaryInformationCell
            configure(cell: supplementaryCell, fetchPromise: controller.getSupplementaryInformation())
            return supplementaryCell
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SweatTemperatureCell.reuseID, for: indexPath) as! SweatTemperatureCell
            return cell
        
        }
    }
        
    func configure<Cell : ConfigurableCell, ResultType>(cell: Cell, fetchPromise: Promise<ResultType>) {
        fetchPromise.done { result in
            cell.configure(data: result as! Cell.DataType)  //JLI: Ideally, we shouldnt need ! or casting
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
