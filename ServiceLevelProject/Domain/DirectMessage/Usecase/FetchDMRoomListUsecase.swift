//
//  FetchDMRoomListUsecase.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/03/01.
//

import Foundation

protocol FetchDMRoomListUsecase {
    func excute(workspaceId: Int) async throws -> [(DirectMessageRoom, String, Int)]
}

final class DefaultFetchDMRoomListUsecase {
    let dmRepository: DirectMessageRepository
    let chattingRepository: ChattingRepository
    
    init(dmRepository: DirectMessageRepository, chattingRepository: ChattingRepository) {
        self.dmRepository = dmRepository
        self.chattingRepository = chattingRepository
    }
}

extension DefaultFetchDMRoomListUsecase: FetchDMRoomListUsecase {
    func excute(workspaceId: Int) async throws -> [(DirectMessageRoom, String, Int)] {
        let fetchDMRoomList = try await dmRepository.fetchDirectMessageRoomList(.init(workspaceId: workspaceId))
        let recentContentList =  await withTaskGroup(of: (String?, Int).self) { taskGroup -> [(String?, Int)] in
            for dm in fetchDMRoomList {
                taskGroup.addTask {
                    let chattingList = try? await self.dmRepository.fetchDMChattingList(.init(audienceId: dm.user.id, workspaceId: workspaceId, cursorDate: nil))
                    var fetchChattingList = await self.chattingRepository.fetchDMChatting(.init(workspaceId: workspaceId, audienceId: dm.user.id))
                    let lastChattingDate = fetchChattingList.last?.createdAt
                    let notReadCount = try? await self.dmRepository.fetchNotReadChattingCount(.init(roomId: dm.roomId, workspaceId: workspaceId, cursorDate: lastChattingDate))
                    return (chattingList?.chats.sorted { $0.createdAt > $1.createdAt }.first?.content, notReadCount ?? 0)
                }
            }
            var contentList: [(String?, Int)] = []
            for await value in taskGroup {
                contentList.append((value.0, value.1))
            }
            return contentList
        }
        return zip(fetchDMRoomList, recentContentList).map { ($0, $1.0 ?? "", $1.1) }
    }
}
