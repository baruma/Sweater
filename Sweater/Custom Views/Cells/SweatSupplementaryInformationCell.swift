//
//  SweatSupplementaryWeatherInformationCell.swift
//  Sweater
//
//  Created by Liana Haque on 1/19/21.
//

import UIKit

class SweatSupplementaryInformationCell: UICollectionViewCell, ConfigurableCell {
    static let reuseID                  = "SweatSupplementaryInformationCell"
    
    /// Base stackview holds onto the uviAndCloudsStackView and the windspeedandPressureStackView.
    let containerStackView = UIStackView()
    
    /// Stackviews to hold onto 2 pieces of supplementary information at a time
    let uviAndCloudsStackView           = UIStackView()
    let windspeedAndPressureStackView   = UIStackView()
    
    /// Stackviews to hold onto UVI labels, cloud labels, windspeed labels and pressure labels respectively.
    let uviStackView        = UIStackView()
    let cloudStackView      = UIStackView()
    let windSpeedStackView  = UIStackView()
    let pressureStackView   = UIStackView()
    
    /// Labels that will be fitted into StackViews.  UVI, Cloud, Windspeed and Pressure labels declared respectively.
    ///
    /// Title Labels
    let uviTitleLabel       = SweatMainLabel()
    let cloudTitleLabel     = SweatMainLabel()
    let windSpeedTitleLabel = SweatMainLabel()
    let pressureTitleLabel  = SweatMainLabel()
    
    /// Data Labels
    let uviDataLabel        = SweatDetailLabel()
    let cloudDataLabel      = SweatDetailLabel()
    let windSpeedDataLabel  = SweatDetailLabel()
    let pressureDataLabel   = SweatDetailLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(data: SupplementaryInformation) {
        uviDataLabel.text       = String(data.uvi)
        cloudDataLabel.text     = String(data.clouds)
        windSpeedDataLabel.text = String(data.windSpeed.rounded(.up))
        pressureDataLabel.text  = String(data.pressure)
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        /// Container stackview that holds onto the parent stackviews adds subviews  here along with its stackview attributes.
        containerStackView.addArrangedSubview(uviAndCloudsStackView)
        containerStackView.addArrangedSubview(windspeedAndPressureStackView)
        contentView.addSubview(containerStackView)
        
        containerStackView.translatesAutoresizingMaskIntoConstraints    = false
        containerStackView.axis                                         = .vertical
        containerStackView.distribution                                 = .fillEqually
        
        /// Parent stackviews filled with respective children stackviews.
        uviAndCloudsStackView.addArrangedSubview(uviStackView)
        uviAndCloudsStackView.addArrangedSubview(cloudStackView)
        
        windspeedAndPressureStackView.addArrangedSubview(windSpeedStackView)
        windspeedAndPressureStackView.addArrangedSubview(pressureStackView)
        
        /// Supplementary Information stackviews getting corresponding title and data labels.
        uviStackView.addArrangedSubview(uviTitleLabel)
        uviStackView.addArrangedSubview(uviDataLabel)
        
        cloudStackView.addArrangedSubview(cloudTitleLabel)
        cloudStackView.addArrangedSubview(cloudDataLabel)
        
        windSpeedStackView.addArrangedSubview(windSpeedTitleLabel)
        windSpeedStackView.addArrangedSubview(windSpeedDataLabel)
        
        pressureStackView.addArrangedSubview(pressureTitleLabel)
        pressureStackView.addArrangedSubview(pressureDataLabel)

        /// Setting stackview specific attributes for child stackviews.
        uviStackView.translatesAutoresizingMaskIntoConstraints  = false
        uviStackView.alignment                                  = .center
        uviStackView.axis                                       = .vertical
        uviStackView.distribution                               = .fillEqually
        uviStackView.spacing                                    = 5.0
        
        cloudStackView.translatesAutoresizingMaskIntoConstraints = false
        cloudStackView.alignment                                 = .center
        cloudStackView.axis                                      = .vertical
        cloudStackView.distribution                              = .fillEqually
        cloudStackView.spacing                                   = 5.0
        
        windSpeedStackView.translatesAutoresizingMaskIntoConstraints = false
        windSpeedStackView.alignment                                 = .center
        windSpeedStackView.axis                                      = .vertical
        windSpeedStackView.distribution                              = .fillEqually
        windSpeedStackView.spacing                                   = 5.0
        
        pressureStackView.translatesAutoresizingMaskIntoConstraints = false
        pressureStackView.alignment                                 = .center
        pressureStackView.axis                                      = .vertical
        pressureStackView.distribution                              = .fillEqually
        pressureStackView.spacing                                   = 5.0
        
        uviAndCloudsStackView.translatesAutoresizingMaskIntoConstraints = false
        uviAndCloudsStackView.axis                                  = .horizontal
        uviAndCloudsStackView.distribution                          = .fillEqually
        
        windspeedAndPressureStackView.translatesAutoresizingMaskIntoConstraints = false
        windspeedAndPressureStackView.axis                          = .horizontal
        windspeedAndPressureStackView.distribution                  = .fillEqually
        
        /// Declaring text to make visibility for testing easier.
        uviTitleLabel.text          = "UVI"
        cloudTitleLabel.text        = "CLOUDS"
        windSpeedTitleLabel.text    = "WINDSPEED"
        pressureTitleLabel.text     = "PRESSURE"
        
        /// Content View adding everything in here
        contentView.addSubview(uviAndCloudsStackView)
        contentView.addSubview(windspeedAndPressureStackView)
        
        NSLayoutConstraint.activate([
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            
            uviAndCloudsStackView.widthAnchor.constraint(equalTo: containerStackView.widthAnchor),
            uviAndCloudsStackView.topAnchor.constraint(equalTo: containerStackView.topAnchor),
            uviAndCloudsStackView.bottomAnchor.constraint(equalTo: windspeedAndPressureStackView.topAnchor),
            
            windspeedAndPressureStackView.widthAnchor.constraint(equalTo: containerStackView.widthAnchor),
            windspeedAndPressureStackView.bottomAnchor.constraint(equalTo: containerStackView.bottomAnchor),
            windspeedAndPressureStackView.topAnchor.constraint(equalTo: uviAndCloudsStackView.bottomAnchor, constant: 0),
            
        ])
    }
}
