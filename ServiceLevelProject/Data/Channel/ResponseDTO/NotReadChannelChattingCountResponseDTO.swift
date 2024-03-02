//
//  NotReadChannelChattingCountResponseDTO.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/03/01.
//

import Foundation

struct NotReadChannelChattingCountResponseDTO: Decodable {
    let channelId: Int
    let name: String
    let count: Int
    
    enum CodingKeys: String, CodingKey {
        case channelId = "channel_id"
        case name
        case count
    }
}
