//
//  FetchImageModel.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/27.
//

import SwiftUI
import Alamofire

class FetchImageModel: ObservableObject {
    enum FetchState {
        case empty
        case loading
        case success(Image)
        case failure(Error)
    }
    
    enum FetchImageError: Error {
        case fetchFail
    }
    
    @Published private(set) var imageState: FetchState = .empty
    var url: String
    var imageData: Data?
    
    init(url: String) {
        self.url = url
    }
    
    func fetchImage() {
        let imageURL = "/v1"+url
        SSAC.request(imageURL, interceptor: TokenInterceptor()).response { result in
            switch result.result {
            case .success(let fetchImageData):
                guard let imageData = fetchImageData, let image = UIImage(data: imageData) else {
                    self.imageState = .empty
                    return
                }
                self.imageData = imageData
                self.imageState = .success(Image(uiImage: image))
            case .failure(let error):
                self.imageState = .failure(error)
            }
        }
    }
}
