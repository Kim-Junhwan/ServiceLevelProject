//
//  DefaultDMRepository.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/23.
//

import Foundation
import Alamofire

class DefaultDMRepository: DirectMessageRepository {
    func fetchDirectMessageRoomList(_ query: FetchDirectMessageRoomQuery) async throws -> [DirectMessageRoom] {
        let value = try await SSAC.accessTokenRequest(DirectMessageRouter.fetchDMSRoomList(query)).slpSerializingDecodable([DMRoomResonseDTO].self, responseErrorMapper: MissingDataErrorMapper()).value
        return try value.map{ try $0.toDomain() }
    }
}
