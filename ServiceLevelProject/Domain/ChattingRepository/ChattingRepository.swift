//
//  ChattingRepository.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/28.
//

import Foundation

protocol ChattingRepository {
    func saveChannelChatting(_ channelChatting: [ChannelChatting]) async throws
    func fetchChannelChatting(_ query: FetchChannelChattingQuery) async -> [ChannelChatting] 
    func saveDMChatting(_ dmChatting: DMChattingList) async throws
    func fetchDMChatting(_ query: FetchDMChattingQuery) async -> [DMChatting]
}
