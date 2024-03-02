//
//  CheckPurchaseResponseErrorMapper.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/03/01.
//

import Foundation

struct CheckPurchaseResponseErrorMapper: ResponseErrorMapper {
    enum ResponseError: String, LocalizedError {
        case invalidPurchase = "E82"
        case missingPurchase = "E81"
    }
    
    func mappingError(_ identifier: String) -> Error? {
        return ResponseError(rawValue: identifier)
    }
}
