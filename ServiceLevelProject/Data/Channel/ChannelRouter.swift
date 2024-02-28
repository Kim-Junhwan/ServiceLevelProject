//
//  ChannelRouter.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/23.
//

import Foundation
import Alamofire

enum ChannelRouter: URLRequestConvertible {
    case fetchComeInChannel(Int)
    case createChannel(workspaceId: Int, query: CreateChannelRequestDTO)
    case fetchWorkspaceChannel(workspaceId: Int)
    case fetchDetailChannelInfo(workspaceId: Int, channelName: String)
    
    var method: HTTPMethod {
        switch self {
        case .fetchComeInChannel:
            return .get
        case .createChannel:
            return .post
        case .fetchWorkspaceChannel:
            return .get
        case .fetchDetailChannelInfo:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .fetchComeInChannel(let workspaceId):
            return "/v1/workspaces/\(workspaceId)/channels/my"
        case .createChannel(let workspaceId, _):
            return "/v1/workspaces/\(workspaceId)/channels"
        case .fetchWorkspaceChannel(let workspaceId):
            return "/v1/workspaces/\(workspaceId)/channels"
        case .fetchDetailChannelInfo(let workspaceId, let channelName):
            return "/v1/workspaces/\(workspaceId)/channels/\(channelName)"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        guard let url = URL(string: path) else {
            throw DefaultNetworkingError.failCreateURL
        }
        var request = URLRequest(url: url)
        request.method = method
        switch self {
        case .createChannel(_, let query):
            request = try JSONParameterEncoder().encode(query, into: request)
        default:
            break
        }
        return request
    }
}
