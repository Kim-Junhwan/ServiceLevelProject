//
//  CheckPurchaseRequestDTO.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/03/01.
//

import Foundation

struct CheckPurchaseRequestDTO: Encodable {
    let impUid: String
    let merchantUid: String
    
    enum CodingKeys: String, CodingKey {
        case impUid = "imp_uid"
        case merchantUid = "merchant_uid"
    }
}
