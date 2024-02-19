//
//  FetchImageModel.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/27.
//

import SwiftUI
import PhotosUI


class ImagePickerModel: ObservableObject {
    enum ImageState {
        case empty
        case loading(Progress)
        case success(Image)
        case failure(Error)
    }
    
    enum TransferError: Error {
        case importFail
    }
    
    typealias ImagePickerResult = (Result<Data?, Error>) -> Void
    
    @MainActor @Published private(set) var imageState: ImageState = .empty
    @MainActor @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            if let imageSelection {
                let progress = loadTransferable(from: imageSelection)
                imageState = .loading(progress)
            } else {
                imageState = .empty
            }
        }
    }
    
    let maxSize: CGFloat
    var imageData: Data?
    var url: String? {
        didSet {
            fetchImage(url: url)
        }
    }
    var action: ImagePickerResult?
    
    init(maxSize: CGFloat, imageData: Data?, action: ImagePickerResult? = nil) {
        self.maxSize = maxSize
        self.imageData = imageData
        DispatchQueue.main.async {
            if let imageData = imageData {
                guard let uiImage = UIImage(data: imageData) else {
                    self.imageState = .failure(TransferError.importFail)
                    return
                }
                self.imageState = .success(Image(uiImage: uiImage))
            }
        }
    }
    
    init(maxSize: CGFloat, url: String?, action: ImagePickerResult? = nil) {
        self.maxSize = maxSize
        self.imageData = nil
        fetchImage(url: url)
    }
    
    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: FetchedImage.self) { result in
            DispatchQueue.main.async {
                guard imageSelection == self.imageSelection else {
                    return
                }
                switch result {
                case .success(let fetchImage?):
                    let downSamplingImage = fetchImage.image.downSamplingImage(maxSize: self.maxSize)
                    let downSmaplignImageData = downSamplingImage.jpegData(compressionQuality: 1.0)
                    self.imageData = downSmaplignImageData
                    self.imageState = .success(Image(uiImage: downSamplingImage))
                    self.action?(.success(downSmaplignImageData))
                case .success(nil):
                    self.imageState = .empty
                case .failure(let error):
                    self.imageState = .failure(error)
                    self.action?(.failure(error))
                }
            }
        }
    }
    
    func fetchImage(url: String?) {
        guard let url else {
            DispatchQueue.main.async {
                self.imageState = .empty
            }
            return
        }
        let imageURL = "/v1"+url
        SSAC.request(imageURL, interceptor: TokenInterceptor()).response { result in
            switch result.result {
            case .success(let fetchImageData):
                guard let imageData = fetchImageData, let image = UIImage(data: imageData) else {
                    DispatchQueue.main.async {
                        self.imageState = .empty
                    }
                    return
                }
                self.imageData = imageData
                DispatchQueue.main.async {
                    self.imageState = .success(Image(uiImage: image))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.imageState = .failure(error)
                }
            }
        }
    }
    
    struct FetchedImage: Transferable {
        let image: Data
        
        static var transferRepresentation: some TransferRepresentation {
            DataRepresentation(importedContentType: .jpeg) { data in
                return FetchedImage(image: data)
            }
        }
    }
}
