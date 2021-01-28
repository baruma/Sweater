//
//  LocationResultTableVC.swift
//  Sweater
//
//  Created by Liana Haque on 1/25/21.
//

import UIKit
import CoreLocation
import PromiseKit

// Keep this class as dumb as possible.  Send the location data to the WeatherVC, then have the WeatherVC send this data to the Repository.

class LocationResultTableViewVC: UITableViewController, UISearchResultsUpdating {
    private let geoCoderManager = GeoCoderManager()
    private var geoCodedPlace = ""
    private var locationSearchResult: LocationSearchResult? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    var searchBarText: String = ""
     
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }

    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text)
        searchBarText = searchController.searchBar.text!
        
        self.geoCoderManager.convertUserEntryToSearchableHumanReadableLocation(searchBarEntry: searchBarText).done { result  in
            let cityName = result.locality ?? ""
            let administrativeAreaName = result.administrativeArea ?? ""
            let countryName = result.country ?? ""
            let searchableCityEntry = self.geoCoderManager.convertUserEntryToSearchableHumanReadableLocation(searchBarEntry: cityName)
            let searchableAdministrativeArea = self.geoCoderManager.convertUserEntryToSearchableHumanReadableLocation(searchBarEntry: administrativeAreaName)
            let searchableCountryEntry = self.geoCoderManager.convertUserEntryToSearchableHumanReadableLocation(searchBarEntry: countryName)
          
            self.locationSearchResult = LocationSearchResult(city: cityName,administrativeArea: administrativeAreaName, country: countryName)
            self.tableView.reloadData()
        }.catch { error  in
            print(error)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        
        cell.backgroundColor = .systemGray6
        cell.textLabel?.textColor = .black
        /// TODO: - Need to add a throw instead of a return
        guard let location = locationSearchResult else {
            print("Something went wrong with finding the city and country names.")
            return cell
        }
        
        cell.textLabel?.text = location.city + " " + location.administrativeArea + " " +  location.country
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
