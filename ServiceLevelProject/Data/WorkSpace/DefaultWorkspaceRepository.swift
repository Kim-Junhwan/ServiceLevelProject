//
//  DefaultWorkspaceRepository.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/27.
//

import Alamofire
import Foundation

final class DefaultWorkspaceRepository: WorkspaceRepository {
    
    func fetchWorkspaceMembers(_ query: FetchWorkspaceMembersQuery) async throws -> [UserThumbnail] {
        let fetchMembers = try await SSAC.accessTokenRequest(WorkspaceRouter.fetchWorkspaceMembers(workspaceId: query.workspaceId)).slpSerializingDecodable([UserThumbnailResponseDTO].self, responseErrorMapper: MissingDataErrorMapper()).value
        return fetchMembers.map { .init(id: $0.userId, email: $0.email, nickname: $0.nickname, profileImagePath: $0.profileImage) }
    }
    
    func fetchComeInWorkspaceList() async throws -> WorkspaceList {
        let value = try await SSAC.accessTokenRequest(WorkspaceRouter.fetchComeInWorkspaceList).slpSerializingDecodable([WorkspaceListResponseDTO].self).value
        return .init(list: try value.map({ responseDTO in
            let date = try responseDTO.createdAt.toDate()
            return .init(id: responseDTO.workspaceId, name: responseDTO.name, description: responseDTO.description, thumbnailPath: responseDTO.thumbnail, ownerId: responseDTO.ownerId, createAt: date)
        }))
    }
    
    func createWorkspace(_ query: CreateWorkspaceQuery) async throws -> WorkSpaceThumbnail {
        let value = try await SSAC.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(Data(query.name.utf8), withName: "name")
            multipartFormData.append(query.image, withName: "image", fileName: "\(query.name).jpeg", mimeType: "image/jpeg")
            if let description = query.description {
                multipartFormData.append(Data(description.utf8), withName: "description")
            }
        }, with: WorkspaceRouter.createWorkspace, interceptor: TokenInterceptor())
            .slpSerializingDecodable(WorkspaceListResponseDTO.self).value
        
        return .init(id: value.workspaceId, name: value.name, description: value.description, thumbnailPath: value.thumbnail, ownerId: value.ownerId, createAt: try value.createdAt.toDate())
    }
    
    func editWorkspace(_ query: EditWorkspaceQuery) async throws -> WorkSpaceThumbnail {
        let value = try await SSAC.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(Data(query.name.utf8), withName: "name")
            multipartFormData.append(query.imageData, withName: "image", fileName: "\(query.name).jpeg", mimeType: "image/jpeg")
            if let description = query.description {
                multipartFormData.append(Data(description.utf8), withName: "description")
            }
        }, with: WorkspaceRouter.editWorkspace(workspaceId: query.workspaceId), interceptor: TokenInterceptor())
            .slpSerializingDecodable(WorkspaceListResponseDTO.self).value
        return .init(id: value.workspaceId, name: value.name, description: value.description, thumbnailPath: value.thumbnail, ownerId: value.ownerId, createAt: try value.createdAt.toDate())
    }
    
    func fetchDetailWorkspace(_ query: FetchDetailWorkspaceInfoQuery) async throws -> WorkspaceDetailInfo {
        let value = try await SSAC.accessTokenRequest(WorkspaceRouter.fetchDetailWorkspace(workspaceId: query.workspaceId)).slpSerializingDecodable(DetailWorkspaceInfoResponseDTO.self, responseErrorMapper: MissingDataErrorMapper()).value
        return try value.toDomain()
    }
}
