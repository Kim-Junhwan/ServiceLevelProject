//
//  DefaultWorkspaceRepository.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/27.
//

import Alamofire
import Foundation

final class DefaultWorkspaceRepository: WorkspaceRepository {
    func fetchComeInWorkspaceList() async throws -> WorkspaceList {
        let value = try await SSAC.accessTokenRequest(WorkspaceRouter.fetchComeInWorkspaceList).slpSerializingDecodable([WorkspaceListResponseDTO].self).value
        return .init(list: try value.map({ responseDTO in
            let date = try responseDTO.createdAt.toDate()
            return .init(id: responseDTO.workspaceId, name: responseDTO.name, description: responseDTO.description, thumbnailPath: responseDTO.thumbnail, ownerId: responseDTO.ownerId, createAt: date)
        }))
    }
}
