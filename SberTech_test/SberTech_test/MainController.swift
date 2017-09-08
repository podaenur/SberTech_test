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
class MainController: BaseViewController<MainViewModel>, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate {
    
    private struct Const {
        static let cellNibName = "MainViewCell"
        static let estimateRowHeight: CGFloat = 50
        static let contentInsets = UIEdgeInsetsMake(20, 0, 0, 0)
        static let pinReuseIdentifier = "PinView"
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Life cycle
    
    override func setupUI() {
        super.setupUI()
        
        setup(tableView)
        setup(mapView)
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
        mapView.delegate = self
    }
    
    private func updateMap() {
        if mapView.annotations.count > 0 {
            mapView.removeAnnotations(mapView.annotations)
        }
        
        let annotations = viewModel.annotations
        mapView.addAnnotations(annotations)
        
        mapView.showAnnotations(annotations, animated: true)
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
        viewModel.didSelectCell(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        viewModel.didDeselectCell(at: indexPath.row)
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pin = PinView(annotation: annotation, reuseIdentifier: Const.pinReuseIdentifier)
        pin.pinTintColor = .sb_red
        return pin
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? Annotation else { fatalError() }
        
        viewModel.didSelectPin(withID: annotation.identifier)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        guard let annotation = view.annotation as? Annotation else { fatalError() }
        
        viewModel.didDeselectPin(withID: annotation.identifier)
    }
}
