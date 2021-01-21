//
//  SweatWeeklyWeatherCell.swift
//  Sweater
//
//  Created by Liana Haque on 1/5/21.
//

import UIKit

class SweatWeeklyWeatherCell: UICollectionViewCell, ConfigurableCell {
//    func onDataReceived(weeklyWeather: [WeeklyWeather]) {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "EEE"
//
//        for index in 0...weeklyWeather.count-1 {
//            weeklyViews[index].maxTemperatureLabel.text = String(weeklyWeather[index].temp.max)
//            weeklyViews[index].minTemperatureLabel.text = String(weeklyWeather[index].temp.min)
//            let date = Date(timeIntervalSince1970: TimeInterval(weeklyWeather[index].dt))
//            let dayString = dateFormatter.string(from: date)
//            weeklyViews[index].dayLabel.text = dayString
//        }
//    }
    
    static let reuseID = "SweatWeeklyWeatherCell"
    var weeklyWeatherView = WeeklyWeatherView()
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    var weeklyViews = [WeeklyWeatherView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(data: [WeeklyWeather]) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
    
        for index in 0...data.count-1 {
            weeklyViews[index].maxTemperatureLabel.text = String(data[index].temp.max)
            weeklyViews[index].minTemperatureLabel.text = String(data[index].temp.min)
            let date = Date(timeIntervalSince1970: TimeInterval(data[index].dt))
            let dayString = dateFormatter.string(from: date)
            weeklyViews[index].dayLabel.text = dayString
        }
    }
    
    /// This function generates WeeklyWeatherViews for the 7 Weekly Weather responses receieved from the API call.
    private func generateWeeklyWeatherViews() {
        for index in 0...7 {
            let view = WeeklyWeatherView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            stackView.addArrangedSubview(view)
            weeklyViews.append(view)
        }
    }
        
    private func configure() {
        scrollView.addSubview(stackView)
        contentView.addSubview(scrollView)
        generateWeeklyWeatherViews()
        
     //   layer.backgroundColor                                   = CGColor.init(red: 255, green: 255, blue: 255, alpha: 1.0)
        translatesAutoresizingMaskIntoConstraints               = false
        
        scrollView.translatesAutoresizingMaskIntoConstraints    = false
        scrollView.bounces                                      = true
        scrollView.isScrollEnabled                              = true
        
   //     backgroundColor = .systemBackground
        
     //   scrollView.backgroundColor = .yellow
        stackView.translatesAutoresizingMaskIntoConstraints     = false
        stackView.axis                                          = .horizontal
        stackView.distribution                                  = .equalSpacing
        stackView.spacing                                       = 10.0
      //  stackView.backgroundColor = .blue
        
        #warning("Avoid hard coding because this is going to create issues with smaller devices.")
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
         //   scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            scrollView.widthAnchor.constraint(greaterThanOrEqualTo: contentView.widthAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 160),
                                               
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
         //   stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, constant: 5),
            stackView.heightAnchor.constraint(equalToConstant: 160),
        ])
    }
}
