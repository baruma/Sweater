//
//  ViewController.swift
//  Sweater
//
//  Created by Liana Haque on 12/2/20.
//

import UIKit

class WeatherDisplayVC: UIViewController {
    let weatherResponseRepository = WeatherResponseRepository()
    
    var collectionView: UICollectionView!
    let temperatureView = SweatTransparentView()
    let controller = WeatherDisplayController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let thing = weatherResponseRepository.fetchWeather(latitude: 42.3601, longitude: -71.0589)
        configureCollectionView()
    }
    
    func configureCollectionView() {
        //let layout = UICollectionViewFlowLayout()
        //layout.itemSize = CGSize(width: 100, height: 100)
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: generateLaytout())
        collectionView.backgroundColor = .black
        view.addSubview(collectionView)
        collectionView.register(SweatTemperatureCell.self, forCellWithReuseIdentifier: SweatTemperatureCell.reuseID)
        collectionView.register(SweatTertiaryInformationCell.self, forCellWithReuseIdentifier: SweatTertiaryInformationCell.reuseID)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    func generateLaytout() -> UICollectionViewLayout {
        let currentTempItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.70)))
        //currentTempItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let detailWeatherItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(0.60)))

        let trailingGroup = NSCollectionLayoutGroup.vertical(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.70),
            heightDimension: .fractionalHeight(1.0)),
          subitems: [currentTempItem, currentTempItem])
        
        let leadingGroup = NSCollectionLayoutGroup.vertical(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.30),
            heightDimension: .fractionalHeight(1.0)),
          subitems: [detailWeatherItem, detailWeatherItem, detailWeatherItem])
        
        let nestingGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)), subitems: [trailingGroup, leadingGroup])

        let section = NSCollectionLayoutSection(group: nestingGroup)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}

extension WeatherDisplayVC: UICollectionViewDelegate {}

extension WeatherDisplayVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("Section \(indexPath.section) Row \(indexPath.row) Index \(indexPath.item)")
            
        switch indexPath.section {
        case 0:
            switch indexPath.item {
            case 0, 1:
                let primaryCell = collectionView.dequeueReusableCell(withReuseIdentifier: SweatTemperatureCell.reuseID, for: indexPath) as! SweatTemperatureCell
                controller.getMainTemperature(listener: primaryCell)  // this is where you put your support request in and give your number for the service to call you back on.
                return primaryCell
                        case 2,3,4:
                            let tertiaryCell = collectionView.dequeueReusableCell(withReuseIdentifier: SweatTertiaryInformationCell.reuseID, for: indexPath) as! SweatTertiaryInformationCell
                return tertiaryCell
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
