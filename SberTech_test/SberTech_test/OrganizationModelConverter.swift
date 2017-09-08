//
//  OrganizationModelConverter.swift
//  SberTech_test
//
//  Created by Evgeniy Akhmerov on 07/09/2017.
//  Copyright © 2017 Evgeniy Akhmerov. All rights reserved.
//

import Foundation

struct OrganizationModelConverter {
    
    func convert(_ source: [OrganizationModel]) -> OrganizationModelPairs {
        var buffer = OrganizationModelPairs()
        source.forEach { buffer[$0.identifier] = $0 }
        return buffer
    }
}
