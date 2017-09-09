//
//  MainViewModel.swift
//  SberTech_test
//
//  Created by Evgeniy Akhmerov on 07/09/2017.
//  Copyright © 2017 Evgeniy Akhmerov. All rights reserved.
//

import MapKit

class MainViewModel: BaseViewModel {
    
    // MARK: - Properties
    
    private let dataManager = DataManager.shared
    private var organizationModels = OrganizationModelPairs()
    private var visitModels = [VisitModel]()
    
    var numberOfRows: Int {
        return visitModels.count
    }
    var annotations: [MKAnnotation] {
        return organizationModels.values.map { return Annotation(latitude: $0.latitude,
                                                                 longitude: $0.longitude,
                                                                 identifier: $0.identifier,
                                                                 title: $0.title) }
    }
    var organizationsDidLoad: (() -> Void)?
    var visitsDidLoad: (() -> Void)?
    var didUpdateCellSelection: ((Bool, IndexPath) -> Void)?
    var didUpdatePinSelection: ((Bool, Int) -> Void)?
    
    // MARK: - Life cycle
    
    override func initialSetup() {
        super.initialSetup()
        
        loadAllData()
    }
    
    // MARK: - Public
    
    func cellModel(at indexPath: IndexPath) -> MainViewCellModel {
        let visit = visitModels[indexPath.row]
        let organization = organizationModels[visit.identifier]
        return MainViewCellModel(title: visit.title, detail: organization?.title)
    }
    
    func didSelectCell(at index: Int) {
        //
    }
    
    func didDeselectCell(at index: Int) {
        //
    }
    
    func didSelectPin(withID identifier: Int) {
        //
    }
    
    func didDeselectPin(withID identifier: Int) {
        //
    }
    
    // MARK: - Private
    
    private func loadAllData() {
        dataManager.getOrganizations {
            [weak self] (response) in
            assert(!Thread.isMainThread)
            guard let sSelf = self else { return }
            
            sSelf.handle(response, onSuccess: {
                [weak self] (models) in
                guard let sSelf = self else { return }
                
                DispatchQueue.main.async {
                    sSelf.organizationModels = models
                    sSelf.organizationsDidLoad?()
                }
                
                sSelf.loadVisits()
            })
        }
    }
    
    private func loadVisits() {
        dataManager.getVisits {
            [weak self] (response) in
            assert(!Thread.isMainThread)
            
            self?.handle(response, onSuccess: {
                [weak self] (models) in
                guard let sSelf = self else { return }
                
                DispatchQueue.main.async {
                    sSelf.visitModels = models
                    sSelf.visitsDidLoad?()
                }
            })
        }
    }
    
    private func handle<T>(_ response: Response<T>, onSuccess: (T) -> Void) {
        switch response {
        case .success(let models):
            onSuccess(models)
        case .failure(let error):
            DispatchQueue.main.async {
                self.showError?(error)
            }
        }
    }
}
