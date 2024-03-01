//
//  ChattingRepository.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/28.
//

import Foundation

@MainActor
protocol ChattingRepository {
    func saveChannelChatting(_ channelChatting: [ChannelChatting]) throws
    func fetchChannelChatting(_ query: FetchChannelChattingQuery) -> [ChannelChatting]
    func saveDMChatting(_ dmChatting: DMChattingList) throws
    func fetchDMChatting(_ query: FetchDMChattingQuery) -> [DMChatting]
}
