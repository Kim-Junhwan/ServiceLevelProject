//
//  DirectMessageRepository.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/23.
//

import Foundation

protocol DirectMessageRepository {
    func fetchDirectMessageRoomList(_ query: FetchDirectMessageRoomQuery) async throws -> [DirectMessageRoom]
}
