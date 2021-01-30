//
//  MVPPresenter.swift
//  Sweater
//
//  Created by Liana Haque on 1/15/21.
//

import Foundation

class MVPPresenter<MvpView: MVPView> {
    typealias View = MvpView
    
    var view: MvpView? = nil
    
    func attach(view: MvpView) {
        self.view = view
    }
    
    func detach() {
        self.view = nil
    }
}
