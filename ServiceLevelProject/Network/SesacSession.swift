//
//  SesacSession.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/10.
//

import Foundation
import Alamofire

let SSAC = SesacSession.shared

final class SesacSession: Session {
    
    static let shared: SesacSession = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = NetworkPolicy.defaultTimeoutInterval
        let apiLogger = APIEventLogger()
        return .init(configuration: configuration, interceptor: Interceptor(adapters: [NetworkingBaseAdapter()]), eventMonitors: [apiLogger])
    }()
    
    func accessTokenRequest(_ convertible: URLRequestConvertible, interceptor: RequestInterceptor? = TokenInterceptor()) -> DataRequest {
        return request(convertible, interceptor: interceptor)
    }
}
