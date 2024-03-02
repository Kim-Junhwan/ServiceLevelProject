//
//  ProfileRouter.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/18.
//

import Alamofire
import Foundation

enum ProfileRouter: URLRequestConvertible {
    case fetchMyProfile
    case editProfile(EditProfileRequestDTO)
    case editProfileImage
    case fetchCoinList
    case checkPurchase(CheckPurchaseRequestDTO)
    
    var method: HTTPMethod {
        switch self {
        case .fetchMyProfile:
            return .get
        case .editProfile:
            return .put
        case .editProfileImage:
            return .put
        case .fetchCoinList:
            return .get
        case .checkPurchase:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .fetchMyProfile:
            return "/v1/users/my"
        case .editProfile:
            return "/v1/users/my"
        case .editProfileImage:
            return "/v1/users/my/image"
        case .fetchCoinList:
            return "/v1/store/item/list"
        case .checkPurchase:
            return "/v1/store/pay/validation"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        guard let url = URL(string: path) else {
            throw DefaultNetworkingError.failCreateURL
        }
        var request = URLRequest(url: url)
        request.method = method
        switch self {
        case .editProfile(let editProfileQuery):
            request = try JSONParameterEncoder().encode(editProfileQuery, into: request)
        case .checkPurchase(let checkPurchaseQuery):
            request = try JSONParameterEncoder().encode(checkPurchaseQuery, into: request)
        default:
            break
        }
        return request
    }
}
