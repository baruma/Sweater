//
//  LocationResultTableVC.swift
//  Sweater
//
//  Created by Liana Haque on 1/25/21.
//

import UIKit

class LocationResultVC: UIViewController {
    var resultTableView = UITableView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
    }
    
    func configureResultTableView() {
        resultTableView.dataSource = self
        resultTableView.delegate = self
        resultTableView.backgroundColor = .purple
    }
    
}

extension LocationResultVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = resultTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = "Look at meeeeee I am a ceeeeeeellllll"
        cell.backgroundColor = .cyan
        return cell
    }
}


extension LocationResultVC: UITableViewDelegate {}
