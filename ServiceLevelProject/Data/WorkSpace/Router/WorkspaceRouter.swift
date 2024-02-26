//
//  WorkspaceRouter.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/27.
//

import Foundation
import Alamofire

enum WorkspaceRouter: URLRequestConvertible {
    case fetchComeInWorkspaceList
    case createWorkspace
    case editWorkspace(workspaceId: Int)
    case fetchWorkspaceMembers(workspaceId: Int)
    case fetchDetailWorkspace(workspaceId: Int)
    case inviteMember(InviteMemberRequestDTO, workspaceId: Int)
    
    var method: HTTPMethod {
        switch self {
        case .fetchComeInWorkspaceList:
            return .get
        case .createWorkspace:
            return .post
        case .editWorkspace:
            return .put
        case .fetchWorkspaceMembers:
            return .get
        case .fetchDetailWorkspace:
            return .get
        case .inviteMember:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .fetchComeInWorkspaceList:
            return "/v1/workspaces"
        case .createWorkspace:
            return "/v1/workspaces"
        case .editWorkspace(let workspaceId):
            return "/v1/workspaces/\(workspaceId)"
        case .fetchWorkspaceMembers(let workspaceId):
            return "/v1/workspaces/\(workspaceId)/members"
        case .fetchDetailWorkspace(workspaceId: let workspaceId):
            return "/v1/workspaces/\(workspaceId)"
        case .inviteMember(_, let workspaceId):
            return "/v1/workspaces/\(workspaceId)/members"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        guard let url = URL(string: path) else { throw DefaultNetworkingError.failCreateURL }
        var request = URLRequest(url: url)
        request.method = method
        switch self {
        case .inviteMember(let query, _):
            request = try JSONParameterEncoder().encode(query, into: request)
        default:
            break
        }
        return request
    }
}
