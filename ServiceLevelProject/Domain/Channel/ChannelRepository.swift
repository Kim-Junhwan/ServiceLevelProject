//
//  ChannelRepository.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/21.
//

import Foundation

protocol ChannelRepository {
    func fetchComeInChannel(_ query: FetchComInChannelQuery) async throws -> [ChannelThumbnail]
    func createChannel(_ query: CreateChannelQuery) async throws -> ChannelThumbnail
    func fetchWorkspaceChannel(_ query: FetchWorkspaceChannelQuery) async throws -> [ChannelThumbnail]
}
