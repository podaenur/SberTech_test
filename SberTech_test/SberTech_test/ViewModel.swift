//
//  ViewModel.swift
//  SberTech_test
//
//  Created by Николай Кагала on 16/12/16.
//  Copyright © 2016 e-Legion. All rights reserved.
//

import UIKit

protocol ViewModel {
    
    var context: Any? { get }
    
    var showError: ((Error) -> Void)? { get set }
    
    init(context: Any?)
    
    func initialSetup()
    func viewDidLoad()
    func didBindUIWithViewModel()
    func viewWillAppear(_ animated: Bool)
    func viewDidAppear(_ animated: Bool)
    func viewWillDisappear(_ animated: Bool)
    func viewDidDisappear(_ animated: Bool)
}
