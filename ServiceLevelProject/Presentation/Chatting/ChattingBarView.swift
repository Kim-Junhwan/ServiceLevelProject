//
//  ChattingBarView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/27.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct ChattingBarView: View {
    @Binding var text: String
    @State private var textViewHeight: CGFloat = 32
    @State private var showPhotosPicker: Bool = false
    @ObservedObject var imagePickerModel: MultipleImagePickerModel
    var isFocus: FocusState<Bool>.Binding
    let sendAction: (Message) -> Void
    
    var body: some View {
        HStack(alignment: .bottom) {
            galleryButton
            VStack {
                chattingTextField
                    .focused(isFocus)
                if !imagePickerModel.imageData.isEmpty {
                    ScrollView(.horizontal) {
                        LazyHStack(spacing: 6) {
                            ForEach(imagePickerModel.imageState) { state in
                                pickerImageCell(state: state)
                                    .frame(width: 50, height: 50)
                            }
                        }
                    }
                    .frame(height: 60)
                }
            }
            sendButton
        }
        .padding([.leading, .trailing], 12)
        .padding([.top, .bottom], 4)
        .background(.backgroundPrimary)
        .background(in: .rect(cornerRadius: 8))
        .padding([.leading, .trailing], 16)
        .padding(.bottom, 12)
    }
    
    private var galleryButton: some View {
        Button(action: {
            showPhotosPicker = true
        }, label: {
            Image(systemName: "plus")
                .resizable()
                .frame(width: 18, height: 18)
        })
        .tint(.black)
        .frame(width: 32, height: 32)
        .photosPicker(isPresented: $showPhotosPicker, selection: $imagePickerModel.imageSelection, maxSelectionCount: 5)
        
    }
    
    func pickerImageCell(state: MultipleImagePickerModel.ImageStateModel) -> some View {
        pickerImageView(state: state.state)
            .clipShape(.rect(cornerRadius: 8))
            .overlay(alignment: .topTrailing) {
                Button(action: {
                    imagePickerModel.removeImage(id: state.id)
                }, label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .tint(.black)
                        .frame(width: 6, height: 6)
                        .frame(width: 16, height: 16)
                        .background(.white)
                        .clipShape(Circle())
                        .overlay {
                            Circle()
                                .stroke(.black, lineWidth: 1)
                        }
                })
                .offset(x: 4, y: -4)
            }
            .frame(width: 44, height: 44)
    }
    
    
    @ViewBuilder
    func pickerImageView(state: MultipleImagePickerModel.ImageState) -> some View {
        switch state {
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
    
    var chattingTextField: some View {
        CustomTextView(text: $text, textViewHeight: $textViewHeight)
            .frame(height: textViewHeight)
    }
    
    var sendButton: some View {
        Button(action: {
            sendAction(.init(message: text, photo: ["",""], profilePath: nil, myMsg: false, time: Date(), username: "123"))
        }, label: {
            sendButtonImage
                .resizable()
                .frame(width: 26, height: 26)
        })
        .frame(width: 32, height: 32)
        .disabled(text.isEmpty && imagePickerModel.imageData.isEmpty)
    }
    
    var sendButtonImage: Image {
        if !text.isEmpty || !imagePickerModel.imageData.isEmpty {
            Image(.fillSend)
        } else {
            Image(.send)
        }
    }
}

//#Preview {
//    ChattingBarView(text: .constant(""), imagePickerModel: .init(maxSize: 44, imageData: []), isFocus: .init(<#T##Bool#>)) { _ in
//        
//    }
//}
