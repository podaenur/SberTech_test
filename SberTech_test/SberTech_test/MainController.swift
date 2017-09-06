//
//  MainController.swift
//  SberTech_test
//
//  Created by Evgeniy Akhmerov on 06/09/2017.
//  Copyright © 2017 Evgeniy Akhmerov. All rights reserved.
//

import UIKit
import MapKit

fileprivate struct Const {
    static let cellNibName = "MainViewCell"
    static let estimateRowHeight: CGFloat = 50
    static let contentInsets = UIEdgeInsetsMake(20, 0, 0, 0)
}

class MainController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Private
    
    private func setupUI() {
        setup(tableView)
    }
    
    private func setup(_ tableView: UITableView) {
        let nib = UINib(nibName: Const.cellNibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Const.cellNibName)
        
        tableView.estimatedRowHeight = Const.estimateRowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.backgroundColor = .sb_backgroundTable
        tableView.separatorStyle = .none
        tableView.contentInset = Const.contentInsets
    }
    
    private func setup(_ mapView: MKMapView) {
        //
    }
}

extension MainController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Const.cellNibName, for: indexPath) as! MainViewCell
//        cell.configure(with: <#T##MainViewCellModel#>)
        return cell
    }
}

extension MainController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //
    }
}
