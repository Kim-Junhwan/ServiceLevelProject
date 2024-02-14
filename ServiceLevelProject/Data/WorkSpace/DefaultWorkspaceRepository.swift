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
    
    func createWorkspace(_ query: CreateWorkspaceQuery) async throws -> WorkSpaceThumbnail {
        let value = try await SSAC.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(Data(query.name.utf8), withName: "name")
            multipartFormData.append(query.image, withName: "image", fileName: "\(query.name).jpeg", mimeType: "image/jpeg")
            if let description = query.description {
                multipartFormData.append(Data(description.utf8), withName: "description")
            }
        }, with: WorkspaceRouter.createWorkspace, interceptor: TokenInterceptor())
            .slpSerializingDecodable(WorkspaceListResponseDTO.self).value
        
        return .init(id: value.ownerId, name: value.name, description: value.description, thumbnailPath: value.thumbnail, ownerId: value.ownerId, createAt: try value.createdAt.toDate())
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
        return .init(id: value.ownerId, name: value.name, description: value.description, thumbnailPath: value.thumbnail, ownerId: value.ownerId, createAt: try value.createdAt.toDate())
    }
}
