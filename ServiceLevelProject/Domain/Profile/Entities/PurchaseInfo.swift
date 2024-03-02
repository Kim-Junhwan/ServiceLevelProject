//
//  PurchaseInfo.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/03/01.
//

import Foundation

struct PurchaseInfo {
    let billingId: Int
    let merchantUid: String
    let amount: Int
    let sesacCoin: Int
    let success: Bool
    let createdAt: Date
}
