//
//  DataManager.swift
//  SberTech_test
//
//  Created by Evgeniy Akhmerov on 07/09/2017.
//  Copyright © 2017 Evgeniy Akhmerov. All rights reserved.
//

import Foundation

class DataManager {
    
    private struct Consts {
        static let kBaseURL = "APP_BASE_URL"
    }
    
    // MARK: - Properties
    
    private var noDataReceivedError: Error {
        let userInfo:[AnyHashable: Any] = [NSLocalizedDescriptionKey: "No any data received." as Any]
        return NSError(codedDomain: NSError.Domains.network, userInfo: userInfo)
    }
    private let dataManagementQueue: OperationQueue
    private let networkClient: NetworkManagement
    private let parser: Parsable
    
    static let shared = DataManager()
    
    // MARK: - Life cycle
    
    private init() {
        self.dataManagementQueue = OperationQueue()
        self.dataManagementQueue.underlyingQueue = DispatchQueue(label: "\(Bundle.sb_identifier).DataManager.queue")
        let baseString = Bundle.main.object(forInfoDictionaryKey: Consts.kBaseURL) as! String
        let url = URL(string: baseString)!
        self.networkClient = NetworkClient(baseURL: url)
        self.parser = Parser()
    }
    
    // MARK: - Public
    
    func getOrganizations(completion: @escaping (Response<[OrganizationModelPair], Error>) -> Void) {
        dataManagementQueue.addOperation {
            [unowned self] in
            
            self.networkClient.fetch(.organisations) {
                [unowned self] (response) in
                
                switch response {
                case .success(let data):
                    guard let _data = data else {
                        completion(.failure(self.noDataReceivedError))
                        return
                    }
                    
                    do {
                        let models: [OrganizationModel] = try self.parser.parseArray(_data)
                        let converter = OrganizationModelConverter()
                        completion(.success(converter.convert(models)))
                    } catch {
                        completion(.failure(error))
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func getVisits(completion: @escaping (Response<[VisitModel], Error>) -> Void) {
        dataManagementQueue.addOperation {
            [unowned self] in
            
            self.networkClient.fetch(.visits) {
                (response) in
                
                switch response {
                case .success(let data):
                    guard let _data = data else {
                        completion(.failure(self.noDataReceivedError))
                        return
                    }
                    
                    do {
                        let models: [VisitModel] = try self.parser.parseArray(_data)
                        completion(.success(models))
                    } catch {
                        completion(.failure(error))
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
