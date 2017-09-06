//
//  Entities.swift
//  SberTech_test
//
//  Created by Evgeniy Akhmerov on 05/09/2017.
//  Copyright © 2017 Evgeniy Akhmerov. All rights reserved.
//

import Foundation

struct VisitModel {
    /*
     "title":"Встреча в компании",
     "organizationId":"100"
     */
    
    let identifier: Int
    let title: String
}

struct OrganizationModel {
    /*
     "organizationId":"100",
     "title":"Сбербанк-Технологии",
     "latitude":55.696494,
     "longitude":37.625472
     */
    
//    let identifier: Int
    let title: String
    let latitude: Double
    let longitude: Double
}
