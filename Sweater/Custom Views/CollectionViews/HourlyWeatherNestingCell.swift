//
//  HourlyWeatherNestingCell.swift
//  Sweater
//
//  Created by Liana Haque on 1/2/21.
//

import UIKit

class NestingHourlyWeatherCell: UICollectionViewCell {
    static let reuseID = "HourlyWeatherNestingCell"
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCollectionView()
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SweatHourlyWeatherCell.self, forCellWithReuseIdentifier: SweatHourlyWeatherCell.reuseID)
    }
        
    private func configure() {
        collectionView.backgroundColor = .systemGreen
    }
}

extension NestingHourlyWeatherCell: UICollectionViewDelegate {}

extension NestingHourlyWeatherCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let hourlyWeatherCell = collectionView.dequeueReusableCell(withReuseIdentifier: SweatHourlyWeatherCell.reuseID, for: indexPath) as! SweatHourlyWeatherCell
        return hourlyWeatherCell
    }
}
