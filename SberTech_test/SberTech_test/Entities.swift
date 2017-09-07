//
//  Entities.swift
//  SberTech_test
//
//  Created by Evgeniy Akhmerov on 05/09/2017.
//  Copyright © 2017 Evgeniy Akhmerov. All rights reserved.
//

import Foundation

struct VisitModel {
    let identifier: Int
    let title: String
    
    init?(json: [String: Any]) {
        guard let t = json["title"] as? String,
            let i = json["organizationId"] as? Int else {
                return nil
        }
        
        self.identifier = i
        self.title = t
    }
}

struct OrganizationModel {
    let identifier: Int
    let title: String
    let latitude: Double
    let longitude: Double
    
    init?(json: [String: Any]) {
        guard let i = json["organizationId"] as? Int,
            let t = json["title"] as? String,
            let la = json["latitude"] as? Double,
            let lo = json["longitude"] as? Double else {
                return nil
        }
        
        self.identifier = i
        self.title = t
        self.latitude = la
        self.longitude = lo
    }
}
