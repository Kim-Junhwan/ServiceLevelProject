//
//  SelectimageView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/26.
//

import SwiftUI
import PhotosUI

struct MainImage: View {
    let imageState: ImageModel.ImageState
    
    var body: some View {
        switch imageState {
        case .empty:
            Image(.workspaceBallon)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 48, height: 48)
                .offset(y: 5)
        case .loading:
            ProgressView()
        case .success(let image):
            image.resizable()
        case .failure:
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(.white)
        }
    }
}

struct ImagePickerView: View {
    @ObservedObject var viewModel: ImageModel
    
    var body: some View {
        PhotosPicker(selection: $viewModel.imageSelection, matching: .images, photoLibrary: .shared()) {
            MainImage(imageState: viewModel.imageState)
                .scaledToFill()
                .frame(width: 70, height: 70)
                .background(.brandGreen)
                .clipShape(.rect(cornerRadius: 8))
                .overlay(alignment: .bottomTrailing) {
                    Image(.camera)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .offset(x: 8, y: 7)
                }
        }
    }
}

