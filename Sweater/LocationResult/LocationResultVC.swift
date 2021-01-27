//
//  LocationResultTableVC.swift
//  Sweater
//
//  Created by Liana Haque on 1/25/21.
//

import UIKit

class LocationResultVC: UITableViewController, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    var resultTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        configureResultTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        resultTableView.reloadData()
    }
    
    func configureResultTableView() {
        view.addSubview(resultTableView)
        resultTableView.dataSource = self
        resultTableView.delegate = self
        resultTableView.backgroundColor = .orange
        resultTableView.reloadData()
        
        resultTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        NSLayoutConstraint.activate([
            resultTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            resultTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
           // resultTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            //resultTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
            resultTableView.heightAnchor.constraint(equalToConstant: 500),
            resultTableView.widthAnchor.constraint(equalToConstant: 400)
        ])
    }
    
}
//
//extension LocationResultVC: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    // This isn't even being hit.
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = resultTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
//        cell.textLabel?.text = "Look at meeeeee I am a ceeeeeeellllll"
//        cell.textLabel?.layer.backgroundColor = .init(srgbRed: 255, green: 255, blue: 255, alpha: 1)
//        cell.backgroundColor = .cyan
//        return cell
//    }
//}
//
//
//extension LocationResultVC: UITableViewDelegate {}
