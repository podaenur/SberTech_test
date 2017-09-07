//
//  NSError+Helper.swift
//  SberTech_test
//
//  Created by Evgeniy Akhmerov on 07/09/2017.
//  Copyright © 2017 Evgeniy Akhmerov. All rights reserved.
//

import Foundation

extension NSError {
    
    typealias DomainType = (subDomain: String, errorCode: Int)
    
    enum Domains {
        case app
        case parser
        case network
        
        var type: DomainType {
            switch self {
            case .app:      return (subDomain: "Application", errorCode: 10_000)
            case .parser:   return (subDomain: "Parser", errorCode: 10_100)
            case .network:  return (subDomain: "Network", errorCode: 10_200)
            }
        }
    }
    
    convenience init(codedDomain: Domains, userInfo dict: [AnyHashable: Any]? = nil) {
        let code = codedDomain.type.errorCode
        let domain = "\(Bundle.sb_identifier).\(codedDomain.type.subDomain)"
        self.init(domain: domain, code: code, userInfo: dict)
    }
}
