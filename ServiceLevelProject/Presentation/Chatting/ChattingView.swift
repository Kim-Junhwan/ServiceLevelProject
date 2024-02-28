//
//  ChattingView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/27.
//

import SwiftUI

struct ChattingView: View {
    @Binding var inputText: String
    let chatList: [ChattingMessageModel]
    @ObservedObject var imagePickerModel: MultipleImagePickerModel
    @FocusState private var isFocus: Bool
    let sendButtonAction: () -> Void
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(chatList) { msg in
                            ChatBubble(message: msg)
                        }
                    }
                    .padding(.top, 16)
                    .padding([.leading, .trailing], 16)
                }.onTapGesture {
                    isFocus = false
                }
                ChattingBarView(text: $inputText, imagePickerModel: imagePickerModel, isFocus: $isFocus) {
                    sendButtonAction()
                }
            }
            
        }
    }
}

#Preview {
    ChattingView(inputText: .constant(""), chatList: [], imagePickerModel: .init(maxSize: 44, imageData: [])) {
        
    }
}
