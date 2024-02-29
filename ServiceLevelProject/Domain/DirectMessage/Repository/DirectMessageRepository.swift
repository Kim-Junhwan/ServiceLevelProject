//
//  DirectMessageRepository.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/23.
//

import Foundation

protocol DirectMessageRepository {
    func fetchDirectMessageRoomList(_ query: FetchDirectMessageRoomQuery) async throws -> [DirectMessageRoom]
    func fetchDMChattingList(_ query: FetchDMChattingListQuery) async throws -> DMChattingList
    func postDMChatting(_ query: PostDMChattingQuery) async throws -> DMChatting
}
