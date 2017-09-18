//
//  DataManager.swift
//  SberTech_test
//
//  Created by Evgeniy Akhmerov on 07/09/2017.
//  Copyright © 2017 Evgeniy Akhmerov. All rights reserved.
//

import Foundation

class DataManager {
    
    typealias DataTransform<T, U> = (T) -> U
    
    private struct Consts {
        static let kBaseURL = "APP_BASE_URL"
    }
    
    // MARK: - Properties
    
    private var noDataReceivedError: Error {
        let userInfo:[AnyHashable: Any] = [NSLocalizedDescriptionKey: "No any data received."]
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
    
    func getOrganizations(completion: @escaping (Response<OrganizationModelPairs>) -> Void) {
        getData(fetchType: .organisations, completion: completion) { return OrganizationModelConverter().convert($0) }
    }
    
    func getVisits(completion: @escaping (Response<[VisitModel]>) -> Void) {
        getData(fetchType: .visits, completion: completion) { return $0 }
    }
    
    // MARK: - Private
    
    private func getData<ResultType, IncomeType: JSONInitializable>(fetchType: FetchType,
                         completion: @escaping (Response<ResultType>) -> Void,
                         transform: @escaping DataTransform<[IncomeType], ResultType>) {
        
        dataManagementQueue.addOperation {
            [unowned self] in
            
            self.networkClient.fetch(fetchType) {
                [unowned self] (response) in
                
                switch response {
                case .success(let data):
                    guard let _data = data else {
                        completion(.failure(self.noDataReceivedError))
                        return
                    }
                    
                    do {
                        let models: [IncomeType] = try self.parser.parseArray(_data)
                        completion(.success(transform(models)))
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
