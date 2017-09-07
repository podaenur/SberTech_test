//
//  Bundle+Helper.swift
//  SberTech_test
//
//  Created by Evgeniy Akhmerov on 07/09/2017.
//  Copyright © 2017 Evgeniy Akhmerov. All rights reserved.
//

import Foundation

extension Bundle {
    
    static var sb_identifier: String {
        return self.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as! String
    }
}
