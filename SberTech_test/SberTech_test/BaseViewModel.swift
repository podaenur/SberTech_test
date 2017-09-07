//
//  BaseViewModel.swift
//  SberTech_test
//
//  Created by Sergey Rakov on 04/10/16.
//  Copyright © 2016 e-Legion. All rights reserved.
//

import UIKit

class BaseViewModel: ViewModel {
    
    let context: Any?
    
    // MARK: - Initialization
    
    required init(context: Any?) {
        self.context = context
        initialSetup()
    }
    
    // MARK: - Life Cycle
    
    func initialSetup() {}
    func viewDidLoad() {}
    func didBindUIWithViewModel() {}
    func viewWillAppear(_ animated: Bool) {}
    func viewDidAppear(_ animated: Bool) {}
    func viewWillDisappear(_ animated: Bool) {}
    func viewDidDisappear(_ animated: Bool) {}
}
