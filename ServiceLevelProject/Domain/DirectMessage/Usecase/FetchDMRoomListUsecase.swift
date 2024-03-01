//
//  FetchDMRoomListUsecase.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/03/01.
//

import Foundation

protocol FetchDMRoomListUsecase {
    func excute(workspaceId: Int) async throws -> [(DirectMessageRoom, String)]
}

final class DefaultFetchDMRoomListUsecase {
    let dmRepository: DirectMessageRepository
    
    init(dmRepository: DirectMessageRepository) {
        self.dmRepository = dmRepository
    }
}

extension DefaultFetchDMRoomListUsecase: FetchDMRoomListUsecase {
    func excute(workspaceId: Int) async throws -> [(DirectMessageRoom, String)] {
        let fetchDMRoomList = try await dmRepository.fetchDirectMessageRoomList(.init(workspaceId: workspaceId))
        let recentContentList =  await withTaskGroup(of: String?.self) { taskGroup -> [String?] in
            for dm in fetchDMRoomList {
                taskGroup.addTask {
                    let chattingList = try? await self.dmRepository.fetchDMChattingList(.init(audienceId: dm.user.id, workspaceId: workspaceId, cursorDate: nil))
                    return chattingList?.chats.sorted { $0.createdAt > $1.createdAt }.first?.content
                }
            }
            var contentList: [String?] = []
            for await value in taskGroup {
                contentList.append(value)
            }
            return contentList
        }
        return zip(fetchDMRoomList, recentContentList).map { ($0, $1 ?? "") }
    }
}
