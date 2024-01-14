//
//  ResponseErrorMapper.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/14.
//

import Foundation

protocol ResponseErrorMapper {
    associatedtype ResponseError: Error
    func mappingError(_ identifier: String) -> Error?
}
