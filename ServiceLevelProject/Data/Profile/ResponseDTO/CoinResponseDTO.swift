//
//  CoinResponseDTO.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/29.
//

import Foundation

struct CoinResponseDTO: Decodable {
    let item: String
    let amount: String
    
    func toDomain() -> Coin {
        return .init(item: item, amount: amount)
    }
}
