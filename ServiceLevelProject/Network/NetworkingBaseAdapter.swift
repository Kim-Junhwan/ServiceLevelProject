//
//  DefaultAdapter.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/10.
//

import Foundation
import Alamofire

struct NetworkingBaseAdapter: RequestAdapter {
    
    func adapt(_ urlRequest: URLRequest, for session: Alamofire.Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        guard let baseURL = Bundle.main.infoDictionary?["SESAC_BASE_URL"] as? String else { return }
        guard let SLPAPIKey = Bundle.main.infoDictionary?["SESAC_APP_KEY"] as? String,
              let path = urlRequest.url?.absoluteString,
              let requestURL = URL(string: "\(baseURL)\(path)")
        else {
            completion(.failure(DefaultNetworkingError.failSetBaseURLRequest))
            return
        }
        urlRequest.headers.add(name: "SesacKey", value: SLPAPIKey)
        urlRequest.url = requestURL
        completion(.success(urlRequest))
    }
    
}

