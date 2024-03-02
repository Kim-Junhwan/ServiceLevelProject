//
//  CheckPurchaseResponseDTO.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/03/01.
//

import Foundation

struct CheckPurchaseResponseDTO: Decodable {
    let billingId: Int
    let merchantUid: String
    let amount: Int
    let sesacCoin: Int
    let success: Bool
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case billingId = "billing_id"
        case merchantUid = "merchant_uid"
        case amount
        case sesacCoin
        case success
        case createdAt
    }
    
    func toDomain() throws -> PurchaseInfo {
        return .init(billingId: billingId, merchantUid: merchantUid, amount: amount, sesacCoin: sesacCoin, success: success, createdAt: try createdAt.toDate())
    }
}
