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
    
    init(maxSize: CGFloat, imageData: Data?) {
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
    
    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: FetchedImage.self) { result in
            DispatchQueue.main.async {
                guard imageSelection == self.imageSelection else {
                    return
                }
                switch result {
                case .success(let fetchImage?):
                    let downSamplingImage = fetchImage.image.downSamplingImage(maxSize: self.maxSize)
                    self.imageData = downSamplingImage.jpegData(compressionQuality: 1.0)
                    self.imageState = .success(Image(uiImage: downSamplingImage))
                case .success(nil):
                    self.imageState = .empty
                case .failure(let error):
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
