//
//  SweatHourlyScrollCell.swift
//  Sweater
//
//  Created by Liana Haque on 1/2/21.
//

import UIKit

class SweatHourlyWeatherCell: UICollectionViewCell {
    func onDataReceived(hourlyWeather: [HourlyWeather]) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH a"
    
        for index in 0...hourlyWeather.count-1 {
            hourlyViews[index].temperatureLabel.text = String(hourlyWeather[index].temp)
            
            let date = Date(timeIntervalSince1970: TimeInterval(hourlyWeather[index].dt))
            let hourString = dateFormatter.string(from: date)
            hourlyViews[index].timeLabel.text = hourString
        }
    }
    
    static let reuseID = "SweatHourlyWeatherCell"
    var hourlyWeatherView = HourlyWeatherView()
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    var hourlyViews = [HourlyWeatherView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// This function generates HourlyWeatherDetailViews for the 48 Hourly Weather responses receieved from the API call.
    
    // MOVE THIS UP IN THE PROTOCOL
    // DON'T CREATE THE VIEW TILL YOU KNOW HOW MANY CELLS ARE AVAILABLE
    // CREATE CHECK AGAINST REFRESHES THAT WILL PREVENT 48 MORE CELLS FROM BEING MADE
    private func generateHourlyWeeklyWeatherViews() {
        for index in 0...48 {
            let view = HourlyWeatherView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            stackView.addArrangedSubview(view)
            hourlyViews.append(view)
        }
    }
        
    private func configure() {
        scrollView.addSubview(stackView)
        contentView.addSubview(scrollView)
        generateHourlyWeeklyWeatherViews()
        
        layer.backgroundColor                                   = CGColor.init(red: 255, green: 255, blue: 255, alpha: 1.0)
        translatesAutoresizingMaskIntoConstraints               = false
        
        scrollView.translatesAutoresizingMaskIntoConstraints    = false
        scrollView.bounces                                      = true
        scrollView.isScrollEnabled                              = true
        
        stackView.translatesAutoresizingMaskIntoConstraints     = false
        stackView.axis                                          = .horizontal
        stackView.distribution                                  = .equalSpacing
        stackView.spacing                                       = 10.0
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            scrollView.widthAnchor.constraint(greaterThanOrEqualTo: contentView.widthAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 120),
                                               
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0),
            stackView.heightAnchor.constraint(equalToConstant: 120),
        ])
    }
}
