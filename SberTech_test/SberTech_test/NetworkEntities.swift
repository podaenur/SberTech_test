//
//  NetworkEntities.swift
//  SberTech_test
//
//  Created by Evgeniy Akhmerov on 07/09/2017.
//  Copyright © 2017 Evgeniy Akhmerov. All rights reserved.
//

import Foundation

enum FetchType: String {
    case organisations = "getOrganizationListTest"
    case visits = "getVisitsListTest"
    
    //TODO: проработать ошибки
    /*
     case organisations = "getOrganizationListTest_1"
     case visits = "getVisitsListTest_1"
     */
}

typealias FetchCompletion = (Response<Data?, Error>) -> Void

protocol NetworkManagement {
    func fetch(_ type: FetchType, completion: @escaping FetchCompletion)
}
