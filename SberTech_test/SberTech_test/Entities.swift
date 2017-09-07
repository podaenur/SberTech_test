//
//  Entities.swift
//  SberTech_test
//
//  Created by Evgeniy Akhmerov on 05/09/2017.
//  Copyright © 2017 Evgeniy Akhmerov. All rights reserved.
//

import Foundation

protocol JSONInitializable {
    init?(json: [String: Any])
}

protocol Parsable {
    func parseArray<T: JSONInitializable>(_ data: Data) throws -> [T]
}

struct VisitModel: JSONInitializable {
    
    private struct Keys {
        static let identifier = "organizationId"
        static let title = "title"
    }
    
    let identifier: Int
    let title: String
    
    init?(json: [String: Any]) {
        guard
            let t = json[Keys.title] as? String,
            let i = json[Keys.identifier] as? String,
            let _i = Int(i)
            else { return nil
        }
        
        self.identifier = _i
        self.title = t
    }
}

struct OrganizationModel: JSONInitializable {
    
    private struct Keys {
        static let identifier = "organizationId"
        static let title = "title"
        static let latitude = "latitude"
        static let longitude = "longitude"
    }
    
    let identifier: Int
    let title: String
    let latitude: Double
    let longitude: Double
    
    init?(json: [String: Any]) {
        guard
            let i = json[Keys.identifier] as? String,
            let _i = Int(i),
            let t = json[Keys.title] as? String,
            let la = json[Keys.latitude] as? Double,
            let lo = json[Keys.longitude] as? Double
            else { return nil
        }
        
        self.identifier = _i
        self.title = t
        self.latitude = la
        self.longitude = lo
    }
}
