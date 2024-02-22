//
//  FetchImageFromServerView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/27.
//

import Foundation
import SwiftUI

struct FetchingImage<PlaceHolder: View>: View  {
    let imageState: FetchImageModel.FetchState
    let placeHolder: () -> PlaceHolder
    
    var body: some View {
        switch imageState {
        case .empty:
            placeHolder()
        case .loading:
            ProgressView()
        case .success(let image, _):
            image
                .resizable()
                .scaledToFill()
        case .failure(let error):
            placeHolder()
        }
    }
}

struct FetchImageFromServerView<PlaceHolder: View>: View {
    @ObservedObject private var viewModel: FetchImageModel
    let placeHolder: () -> PlaceHolder
    
    init(url: String?, placeHolder: @escaping () -> PlaceHolder) {
        _viewModel = .init(wrappedValue: FetchImageModel(url: url))
        self.placeHolder = placeHolder
    }
    
    init(imageModel: FetchImageModel, placeHolder: @escaping () -> PlaceHolder) {
        viewModel = imageModel
        self.placeHolder = placeHolder
    }
    
    var body: some View {
        FetchingImage(imageState: viewModel.imageState, placeHolder: placeHolder)
            .background(.brandGray)
            .onAppear {
                viewModel.fetchImage()
            }
    }
}
