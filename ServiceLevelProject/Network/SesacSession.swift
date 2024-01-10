//
//  SesacSession.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/10.
//

import Foundation
import Alamofire

let SSAC = SesacSession.shared

private final class SesacSession {
    static let shared: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = NetworkPolicy.defaultTimeoutInterval
        return Session(configuration: configuration)
    }()
    
    private init() {}
}
