//
//  MainViewModel.swift
//  SberTech_test
//
//  Created by Evgeniy Akhmerov on 07/09/2017.
//  Copyright © 2017 Evgeniy Akhmerov. All rights reserved.
//

import Foundation

class MainViewModel: BaseViewModel {
    
    // MARK: - Properties
    
    private let dataManager = DataManager.shared
    private var organizationModels = OrganizationModelPairs()
    private var visitModels = [VisitModel]()
    
    var numberOfRows: Int {
        return visitModels.count
    }
    var organizationsDidLoad: (() -> Void)?
    var visitsDidLoad: (() -> Void)?
    
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
    
    // MARK: - Private
    
    private func loadAllData() {
        dataManager.getOrganizations {
            [weak self] (response) in
            guard let sSelf = self else { return }
            
            switch response {
            case .success(let models):
                DispatchQueue.main.async {
                    sSelf.organizationModels = models
                    sSelf.organizationsDidLoad?()
                }
                sSelf.loadVisits()
                
            case .failure(let error):
                sSelf.handle(error)
            }
        }
    }
    
    private func loadVisits() {
        dataManager.getVisits {
            [weak self] (response) in
            guard let sSelf = self else { return }
            
            switch response {
            case .success(let models):
                DispatchQueue.main.async {
                    sSelf.visitModels = models
                    sSelf.visitsDidLoad?()
                }
                
            case .failure(let error):
                sSelf.handle(error)
            }
        }
    }
    
    private func handle(_ error: Error) {
        DispatchQueue.main.async {
            self.showError?(error)
        }
    }
}
