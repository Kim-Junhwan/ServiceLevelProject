//
//  DirectMessageRouter.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/23.
//

import Alamofire
import Foundation

enum DirectMessageRouter: URLRequestConvertible {
    case fetchDMSRoomList(FetchDirectMessageRoomQuery)
    
    var method: HTTPMethod {
        switch self {
        case .fetchDMSRoomList:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .fetchDMSRoomList(let query):
            return "/v1/workspaces/\(query.workspaceId)/dms"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        guard let url = URL(string: path) else {
            throw DefaultNetworkingError.failCreateURL
        }
        var request = URLRequest(url: url)
        request.method = method
        switch self {
        default:
            break
        }
        return request
    }
}
