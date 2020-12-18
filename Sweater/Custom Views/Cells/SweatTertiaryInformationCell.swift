//
//  TertiaryInformationCell.swift
//  Sweater
//
//  Created by Liana Haque on 12/14/20.
//

import UIKit

class SweatTertiaryInformationCell: UICollectionViewCell {
    static let reuseID = "TertiaryCell"
    let mainTemperatureLabel = SweatMainLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentView.addSubview(mainTemperatureLabel)
        translatesAutoresizingMaskIntoConstraints = false
        layer.backgroundColor = CGColor.init(red: 255, green: 250, blue: 250, alpha: 1)
        mainTemperatureLabel.backgroundColor = .blue
        mainTemperatureLabel.text = "SCREAMING BLUE"

        NSLayoutConstraint.activate([
            mainTemperatureLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            mainTemperatureLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            mainTemperatureLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            mainTemperatureLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}


/*
 static let reuseID = "OptionCell"
 
 var rowIndex = -1
 var textChangeListener: OptionTextChangeListener? = nil

 let optionTextView = BodyTextView(frame: .zero)

 override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
     super.init(style: style, reuseIdentifier: reuseIdentifier)
     configure()
 }

 override func setSelected(_ selected: Bool, animated: Bool) { super.setSelected(selected, animated: animated) }
 
 required init?(coder: NSCoder) {
     fatalError("init(coder:) has not been implemented")
 }
 
 func setTextChangeListener(listener: OptionTextChangeListener) { textChangeListener = listener }
 
 func textViewDidChange(_ textView: UITextView) { textChangeListener?.onTextChange(row: rowIndex, text: optionTextView.text) }
 
 private func configure() {
     contentView.addSubview(optionTextView)
     optionTextView.delegate = self
     optionTextView.textColor                    = .systemGray
     self.selectionStyle                         = .none
     translatesAutoresizingMaskIntoConstraints   = false
     let padding: CGFloat                        = 40

     NSLayoutConstraint.activate([
         optionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
         optionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
         optionTextView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
         optionTextView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
         optionTextView.heightAnchor.constraint(equalToConstant: 60)
     ])
 }
 */
