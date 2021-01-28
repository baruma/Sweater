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
    private var suggestedPlace = ""
    private var suggestedCity = ""
    private var suggestedCountry = ""
    
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
    
    // We need a function that returns the readable and tableviewcell insertable placename because updateSearchResults hates this.
    
    func updateSearchResults(for searchController: UISearchController, fetchPromise: Promise<CLPlacemark>) {
        print(searchController.searchBar.text)
    
        searchBarText = searchController.searchBar.text!
        
        fetchPromise.done { result  in
            let cityName = result.locality
            let countryName = result.country
            let searchableCityEntry = self.geoCoderManager.convertUserEntryToSearchableHumanReadableLocation(searchBarEntry: cityName!)
            let searchableCountryEntry = self.geoCoderManager.convertUserEntryToSearchableHumanReadableLocation(searchBarEntry: countryName!)
            self.suggestedCity = cityName!
            self.suggestedCountry = countryName!
        }.catch { error  in
            print(error)
        }
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
//    func configure<Cell : ConfigurableCell, ResultType>(cell: Cell, fetchPromise: Promise<ResultType>) {
//        fetchPromise.done { result in
//            cell.configure(data: result as! Cell.DataType)  //JLI: Ideally, we shouldnt need ! or casting
//        }.catch { error in
//            print(error)
//        }
//    }
//
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        
        cell.backgroundColor = .systemGray6
        cell.textLabel?.text = searchBarText
        cell.textLabel?.textColor = .black
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
