//
//  CreateChannelRequestDTO.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/24.
//

import Foundation

struct CreateChannelRequestDTO: Encodable {
    let name: String
    let description: String?
}
