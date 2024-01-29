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
    
    var method: HTTPMethod {
        switch self {
        case .fetchComeInWorkspaceList:
            return .get
        case .createWorkspace:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .fetchComeInWorkspaceList:
            return "v1/workspaces"
        case .createWorkspace:
            return "v1/workspaces"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        guard let url = URL(string: path) else { throw DefaultNetworkingError.failCreateURL }
        var request = URLRequest(url: url)
        request.method = method
        
        switch self {
        default:
            break
        }
        return request
    }
}
