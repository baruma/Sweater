//
//  LocationResultTableVC.swift
//  Sweater
//
//  Created by Liana Haque on 1/25/21.
//

import UIKit
import CoreLocation
import PromiseKit

class LocationResultTableViewVC: UITableViewController, UISearchResultsUpdating {
    private let geoCoderManager = GeoCoderManager()
    private var geoCodedPlace = ""
    var searchBarText: String = ""

    private var locationSearchResult: LocationSearchResult? = nil
    public var locationResultListener: LocationResultListener? = nil
    private var searchController: UISearchController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
     
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

    // The idea to pick out the locationSearchResult from here and pass it back to the VC is bad because it couples the ViewControllers together.
    func updateSearchResults(for searchController: UISearchController) {
        searchBarText = searchController.searchBar.text!
        self.searchController = searchController  
        self.geoCoderManager.convertUserEntryToSearchableHumanReadableLocation(searchBarEntry: searchBarText).done { [self] result in
            let cityName = result.locality ?? ""
            let administrativeAreaName = result.administrativeArea ?? ""
            let countryName = result.country ?? ""
            let latitude = result.location?.coordinate.latitude ?? 0.0
            let longitude = result.location?.coordinate.longitude ?? 0.0
            self.locationSearchResult = LocationSearchResult(city: cityName,administrativeArea: administrativeAreaName, country: countryName, latitude: latitude, longitude: longitude)
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let location = locationSearchResult else {
            print("locationSearchResult is nil.")
            return
        }
        locationResultListener?.onResultSelected(selectedPlacemark: location)
        searchController?.isActive = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
