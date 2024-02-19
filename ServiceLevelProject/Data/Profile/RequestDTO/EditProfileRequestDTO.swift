//
//  EditProdileRequestDTO.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/19.
//

import Foundation

struct EditProfileRequestDTO: Encodable {
    let nickname: String
    let phone: String?
}
