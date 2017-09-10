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
    private var selectedCells: Set<IndexPath>?
    private var selectedPin: Int?
    private var isUpdating = false
    
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
    
    func didSelectCell(at indexPath: IndexPath) {
        update {
            [weak self] in
            guard let sSelf = self else { return }
            
            let selectedVisitID = sSelf.visitModels[indexPath.row].identifier
            guard let selectedOrganizationID = sSelf.organizationModels[selectedVisitID]?.identifier else { fatalError() }
            
            if let oldSelectedCells = sSelf.selectedCells {
                guard let oldSelectedPin = sSelf.selectedPin else { fatalError() }
                
                if oldSelectedPin != selectedOrganizationID {
                    sSelf.selectedPin = selectedOrganizationID
                    sSelf.didUpdatePinSelection?(false, oldSelectedPin)
                    sSelf.didUpdatePinSelection?(true, selectedOrganizationID)
                }

                oldSelectedCells.forEach({ sSelf.didUpdateCellSelection?(false, $0) })
                sSelf.selectedCells = Set([indexPath])
            } else {
                guard sSelf.selectedPin == nil else { fatalError() }
                sSelf.selectedPin = selectedOrganizationID
                sSelf.didUpdatePinSelection?(true, selectedOrganizationID)
                
                sSelf.selectedCells = Set([indexPath])
            }
        }
    }
    
    func didDeselectCell(at indexPath: IndexPath) {
        update {
            [weak self] in
            guard let sSelf = self else { return }
            
            sSelf.selectedCells?.remove(indexPath)
            guard let selected = sSelf.selectedCells, selected.isEmpty else { return }
            sSelf.selectedCells = nil
            guard let selectedPin = sSelf.selectedPin else { fatalError() }
            sSelf.didUpdatePinSelection?(false, selectedPin)
            sSelf.selectedPin = nil
        }
    }
    
    func didSelectPin(withID identifier: Int) {
        update {
            [weak self] in
            guard let sSelf = self else { return }
            
            guard sSelf.selectedPin == nil, sSelf.selectedCells == nil else { fatalError() }
            guard let organizationID = sSelf.organizationModels[identifier]?.identifier else { fatalError() }
            
            var indices = Set<IndexPath>()
            for (index, item) in sSelf.visitModels.enumerated() {
                if item.identifier != organizationID { continue }
                indices.insert(IndexPath(row: index, section: 0))
            }
            
            sSelf.selectedPin = identifier
            sSelf.selectedCells = indices
            indices.forEach({ sSelf.didUpdateCellSelection?(true, $0) })
        }
    }
    
    func didDeselectPin(withID identifier: Int) {
        update {
            [weak self] in
            guard let sSelf = self else { return }
            
            if let indices = sSelf.selectedCells {
                indices.forEach({ sSelf.didUpdateCellSelection?(false, $0) })
                sSelf.selectedCells = nil
            }
            
            sSelf.selectedPin = nil
        }
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
    
    private func update(execute: @escaping () -> Void) {
        guard !isUpdating else { return }
        
        DispatchQueue.main.async {
            self.isUpdating = true
            execute()
            self.isUpdating = false
        }
    }
}
