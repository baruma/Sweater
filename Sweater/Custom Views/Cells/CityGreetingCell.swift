//
//  CityGreetingCell.swift
//  Sweater
//
//  Created by Liana Haque on 1/29/21.
//

import UIKit

class CityGreetingCell: UICollectionViewCell {
    // This cell is bound to the VC where it is called (this cell is just a class for a Cell.  It should have no other functionality besides being an object that can be used by the VC).  The data below is received because the ViewController called this function and fed it the LocationSearchResult data which can be used to supply the cityLabel with the data it needs.
    // This function here exists so that it can get the selectedPlacemark data from the VC.  The data is here and now we can set the string accordingly.
    func updateCityNameAfterSearch(selectedPlacemark: LocationSearchResult) {
        let city = selectedPlacemark.city
        let administrativeArea = selectedPlacemark.administrativeArea
        let country = selectedPlacemark.country
        cityLabel.text = city + " " + administrativeArea + " " + country
    }
    
    static let reuseID = "CityGreetingCell"
    private var cityLabel = SweatCityGreetingLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(cityLabel)        
        cityLabel.textColor                         = .white
        cityLabel.textAlignment                     = .left
        cityLabel.text                              = "New York, NY"
        translatesAutoresizingMaskIntoConstraints   = false

        
        NSLayoutConstraint.activate([
            cityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            cityLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            cityLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        ])
    }

}
