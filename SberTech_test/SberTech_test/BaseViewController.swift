//
//  BaseViewController.swift
//  SberTech_test
//
//  Created by Sergey Rakov on 04/10/16.
//  Copyright © 2016 e-Legion. All rights reserved.
//

import UIKit

class BaseViewController<ViewModelType: ViewModel>: UIViewController {
    
    var viewModel: ViewModelType!
    
    // MARK: - Initialization
    
    init(viewModel: ViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = BaseViewModel(context: nil) as! ViewModelType
        assert(false, "Wrong initializer.")
        super.init(coder: aDecoder)
    }
    
    // MARK: - Life Cycle
    
    func initialSetup() {}
    
    func setupUI() {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        setupUI()
        bindUIWithViewModel()
        viewModel.didBindUIWithViewModel()
    }
    
    func bindUIWithViewModel() {
        viewModel.showError = {
            [weak self] in
            
            self?.showAlertError($0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.viewDidDisappear(animated)
    }
    
    // MARK: - Private
    
    private func showAlertError(_ error: Error) {
        let controller = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "Close", style: .default)
        controller.addAction(action)
        present(controller, animated: true)
    }
}
