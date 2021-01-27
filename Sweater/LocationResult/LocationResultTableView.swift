//
//  LocationResultTableVC.swift
//  Sweater
//
//  Created by Liana Haque on 1/25/21.
//

import UIKit

class LocationResultTableView: UITableViewController, UISearchResultsUpdating {
    
    var resultTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureResultTableView()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        resultTableView.reloadData()
    }
    
    func configureResultTableView() {
        view.addSubview(resultTableView)
        resultTableView.dataSource = self
        resultTableView.delegate = self
        resultTableView.reloadData()
        resultTableView.backgroundColor = .orange
        resultTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        NSLayoutConstraint.activate([
            resultTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            resultTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            resultTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            resultTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)

        ])
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text)
        resultTableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = resultTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        
        cell.textLabel?.text = navigationItem.searchController?.searchBar.text
        cell.textLabel?.layer.backgroundColor = .init(srgbRed: 255, green: 255, blue: 255, alpha: 1)
        return cell
    }
    
}
