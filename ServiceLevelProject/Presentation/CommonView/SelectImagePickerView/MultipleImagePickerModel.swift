//
//  MultipleImagePickerModel.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/27.
//

import SwiftUI
import PhotosUI


class MultipleImagePickerModel: ObservableObject {
    enum ImageState {
        case empty
        case loading(Progress)
        case success(Image)
        case failure(Error)
    }
    
    struct ImageStateModel: Identifiable {
        let id: UUID = .init()
        var state: ImageState
    }
    
    enum TransferError: Error {
        case importFail
    }
    
    typealias ImagePickerResult = (Result<Data?, Error>) -> Void
    
    @MainActor @Published private(set) var imageState: [ImageStateModel] = []
    @MainActor @Published var imageSelection: [PhotosPickerItem] = [] {
        didSet {
            let addImageItem = imageSelection.enumerated().filter { !oldValue.contains($0.element) }
            for _ in addImageItem {
                imageData.append(nil)
                imageState.append(.init(state: .empty))
            }
            for newImageItem in addImageItem {
                let progress = loadTransferable(from: newImageItem.element, index: newImageItem.offset)
                imageState[newImageItem.offset].state = .loading(progress)
            }
        }
    }
    
    let maxSize: CGFloat
    var imageData: [Data?] = []
    var action: ImagePickerResult?
    
    init(maxSize: CGFloat, imageData: [Data], action: ImagePickerResult? = nil) {
        self.maxSize = maxSize
        self.imageData = imageData
        DispatchQueue.main.async {
            imageData.forEach { imageDataItem in
                guard let uiImage = UIImage(data: imageDataItem) else {
                    self.imageState.append(.init(state: .failure(TransferError.importFail)))
                    return
                }
                self.imageState.append(.init(state: .success(Image(uiImage: uiImage))))
            }
        }
    }
    
    private func loadTransferable(from imageSelection: PhotosPickerItem, index: Int) -> Progress {
        return imageSelection.loadTransferable(type: FetchedImage.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchImage?):
                    let downSamplingImage = fetchImage.image.downSamplingImage(maxSize: self.maxSize)
                    let downSmaplignImageData = downSamplingImage.jpegData(compressionQuality: 1.0)
                    self.imageData[index] = downSmaplignImageData
                    self.imageState[index] = .init(state: .success(Image(uiImage: downSamplingImage)))
                    self.action?(.success(downSmaplignImageData))
                case .success(nil):
                    self.imageState[index] = .init(state: .empty)
                case .failure(let error):
                    self.imageState[index] = .init(state: .failure(error))
                    self.action?(.failure(error))
                }
            }
        }
    }
    
    @MainActor
    func removeImage(id: UUID) {
        guard let removedIndex = imageState.firstIndex(where: { $0.id == id }) else { return }
        imageData.remove(at: removedIndex)
        imageState.remove(at: removedIndex)
        imageSelection.remove(at: removedIndex)
    }
    
    @MainActor
    func removeAll() {
        imageData.removeAll()
        imageState.removeAll()
        imageSelection.removeAll()
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
