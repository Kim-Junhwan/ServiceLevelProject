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
    case fetchDMChattingList(audienceId: Int, workspaceId: Int, cursorDate: Date?)
    case postChatting(roomId: Int, workspaceId: Int)
    case fetchNotReadChattingCount(roomId: Int, workspaceId: Int, cursorDate: Date?)
    
    var method: HTTPMethod {
        switch self {
        case .fetchDMSRoomList:
            return .get
        case .fetchDMChattingList:
            return .get
        case .postChatting:
            return .post
        case .fetchNotReadChattingCount:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .fetchDMSRoomList(let query):
            return "/v1/workspaces/\(query.workspaceId)/dms"
        case .fetchDMChattingList(let audienceId, let workspaceId, _):
            return "/v1/workspaces/\(workspaceId)/dms/\(audienceId)/chats"
        case .postChatting(let roomId, let workspaceId):
            return "/v1/workspaces/\(workspaceId)/dms/\(roomId)/chats"
        case .fetchNotReadChattingCount(let roomId, let workspaceId, _):
            return "/v1/workspaces/\(workspaceId)/dms/\(roomId)/unreads"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        guard let url = URL(string: path) else {
            throw DefaultNetworkingError.failCreateURL
        }
        var request = URLRequest(url: url)
        request.method = method
        switch self {
        case .fetchDMChattingList(_, _, let cursorDate):
            if let cursorDate {
                request.url?.append(queryItems: [.init(name: "cursor_date", value: DateFormatter.defaultFormatter.string(from: cursorDate))])
            }
        case .fetchNotReadChattingCount(_, _, let cursorDate):
            if let cursorDate {
                request.url?.append(queryItems: [.init(name: "after", value: DateFormatter.defaultFormatter.string(from: cursorDate))])
            }
        default:
            break
        }
        return request
    }
}
