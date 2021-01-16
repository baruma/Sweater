//
//  MVPView.swift
//  Sweater
//
//  Created by Liana Haque on 1/15/21.
//

import Foundation

protocol MVPView {
    associatedtype Presenter 
        
    func getPresenter() -> Presenter
}

// Things that can be a MVPView
// ViewController, UIView, UICollectionViewCell

// Things that can be a MVPPresenter
// -> ios SDK class
