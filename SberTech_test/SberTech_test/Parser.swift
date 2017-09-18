//
//  Parser.swift
//  SberTech_test
//
//  Created by Evgeniy Akhmerov on 07/09/2017.
//  Copyright © 2017 Evgeniy Akhmerov. All rights reserved.
//

import Foundation

struct Parser: Parsable {
    
    // MARK: - Properties
    
    private var dataTypeError: Error = {
        let userInfo: [AnyHashable: Any] = [NSLocalizedDescriptionKey: "Parser reached wrong data type in JSON." as Any]
        return NSError(codedDomain: NSError.Domains.parser, userInfo: userInfo) as Error
    }()
    
    // MARK: - Parsable
    
    func parseArray<ResultType: JSONInitializable>(_ data: Data) throws -> [ResultType] {
        let json = try JSONSerialization.jsonObject(with: data) as! Array<[String: Any]>
        let mapped: [ResultType] = try json.map({
            guard let model = ResultType(json: $0) else { throw dataTypeError }
            return model
        })
        return mapped
    }
}
