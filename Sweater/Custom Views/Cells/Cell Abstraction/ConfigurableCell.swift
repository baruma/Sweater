//
//  ConfigurableCell.swift
//  Sweater
//
//  Created by Liana Haque on 1/13/21.
//

import Foundation

protocol ConfigurableCell {
    associatedtype DataType
    func configure(data: DataType)
}
