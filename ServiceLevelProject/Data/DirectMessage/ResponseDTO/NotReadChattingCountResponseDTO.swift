//
//  NotReadChattingCountResponseDTO.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/03/01.
//

import Foundation

struct NotReadChattingCountResponseDTO: Decodable {
    let roomId: Int
    let count: Int
    
    enum CodingKeys: String, CodingKey {
        case roomId = "room_id"
        case count
    }
}
