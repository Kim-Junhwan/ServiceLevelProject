//
//  OutWorkspaceUsecase.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/03/02.
//

import Foundation

protocol OutWorkspaceUsecase {
    func excute(workspaceId: Int) async throws
}

enum OutWorkspaceError: Error {
    case hasChannelAdmin
}

final class DefaultOutWorkspaceUsecase {
    let workspaceRepository: WorkspaceRepository
    let channelRepository: ChannelRepository
    let appState: AppState
    
    init(workspaceRepository: WorkspaceRepository, channelRepository: ChannelRepository, appState: AppState) {
        self.workspaceRepository = workspaceRepository
        self.channelRepository = channelRepository
        self.appState = appState
    }
}

extension DefaultOutWorkspaceUsecase: OutWorkspaceUsecase {
    func excute(workspaceId: Int) async throws {
        let fetchChannelList = try await channelRepository.fetchComeInChannel(.init(workspaceId: workspaceId))
        if fetchChannelList.contains(where: { $0.ownerId == appState.userData.id}) {
            throw OutWorkspaceError.hasChannelAdmin
        }
        appState.workspaceList = try await workspaceRepository.outWorkspace(workspaceId)
    }
    
    
}
