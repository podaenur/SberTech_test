//
//  MainController.swift
//  SberTech_test
//
//  Created by Evgeniy Akhmerov on 06/09/2017.
//  Copyright © 2017 Evgeniy Akhmerov. All rights reserved.
//

import UIKit
import MapKit

/*
 Protocol conformance cann't be extension for generic classes.
 https://bugs.swift.org/browse/SR-4173
 */
class MainController: BaseViewController<MainViewModel>, UITableViewDataSource, UITableViewDelegate {
    
    private struct Const {
        static let cellNibName = "MainViewCell"
        static let estimateRowHeight: CGFloat = 50
        static let contentInsets = UIEdgeInsetsMake(20, 0, 0, 0)
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Life cycle
    
    override func setupUI() {
        super.setupUI()
        
        setup(tableView)
    }
    
    override func bindUIWithViewModel() {
        super.bindUIWithViewModel()
        
        viewModel.organizationsDidLoad = {
            [weak self] in
            self?.updateMap()
        }
        
        viewModel.visitsDidLoad = {
            [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - Private
    
    private func setup(_ tableView: UITableView) {
        let nib = UINib(nibName: Const.cellNibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Const.cellNibName)
        
        tableView.estimatedRowHeight = Const.estimateRowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.contentInset = Const.contentInsets
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.backgroundColor = .sb_backgroundTable
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = true
    }
    
    private func setup(_ mapView: MKMapView) {
        //
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Const.cellNibName, for: indexPath) as! MainViewCell
        cell.configure(with: viewModel.cellModel(at: indexPath))
        return cell
    }
    
    // MARK: - UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
}
