//
//  NetworkClient.swift
//  SberTech_test
//
//  Created by Evgeniy Akhmerov on 05/09/2017.
//  Copyright © 2017 Evgeniy Akhmerov. All rights reserved.
//

import Foundation

enum NetworkResponse {
    case success(Data?)
    case failure(Error)
}

enum FetchType: String {
    case organisations = "getOrganizationListTest"
    case visits = "getVisitsListTest"
    
    //TODO: проработать ошибки
    /*
     case organisations = "getOrganizationListTest_1"
     case visits = "getVisitsListTest_1"
     */
}

typealias FetchCompletion = (NetworkResponse) -> Void

class NetworkClient {
    
    // MARK: - Properties
    
    private let networkQueue = DispatchQueue(label: "\(Bundle.sb_identifier).NetworkClient.queue")
    fileprivate let baseURL: URL
    private let session: URLSession
    
    // MARK: - Life cycle
    
    init(baseURL: URL) {
        self.baseURL = baseURL
        self.session = URLSession(configuration: .default)
    }
    
    // MARK: - Public
    
    func fetch(_ type: FetchType, completion: @escaping FetchCompletion) {
        let request = URLRequest(url: baseURL.appendingPathComponent(type.rawValue))
        execute(request: request, completion: completion)
    }
    
    // MARK: - Private
    
    private func execute(request: URLRequest, completion: @escaping FetchCompletion) {
        networkQueue.async {
            let task = self.session.dataTask(with: request, completionHandler: {
                (data, _, error) in
                if let _error = error {
                    completion(.failure(_error))
                } else {
                    completion(.success(data))
                }
            })
            task.resume()
        }
    }
}
