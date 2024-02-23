//
//  DefaultChanngelRepository.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/23.
//

import Foundation
import Alamofire

final class DefaultChannelRepository: ChannelRepository {
    func fetchComeInChannel(_ query: FetchComInChannelQuery) async throws -> [ChannelThumbnail] {
        let value = try await SSAC.accessTokenRequest(ChannelRouter.fetchComeInChannel(query.workspaceId)).slpSerializingDecodable([ChannelThumbnailResponseDTO].self, responseErrorMapper: MissingDataErrorMapper()).value
        return try value.map{try $0.toDomain()}
    }
    
    
}
