//
//  MainPresenter.swift
//  SberTech_test
//
//  Created by Evgeniy Akhmerov on 06/09/2017.
//  Copyright © 2017 Evgeniy Akhmerov. All rights reserved.
//

import Foundation

class MainPresenter {
    
    // MARK: - Properties
    
    private weak var view: MainViewInput?
    
    // MARK: - Life cycle
    
    init(with view: MainViewInput) {
        self.view = view
    }
}

extension MainPresenter: MainViewOutput {
    
}
