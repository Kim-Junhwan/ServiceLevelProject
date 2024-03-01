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
    @Binding var sendSuccess: Bool
    let sendButtonAction: () -> Void
    @Namespace var scrollViewBottom
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(alignment: .leading) {
                            ForEach(chatList) { msg in
                                ChatBubble(message: msg)
                            }
                        }
                        .id(scrollViewBottom)
                        .padding(.top, 16)
                        .padding([.leading, .trailing], 16)
                    }
                    .onTapGesture {
                        isFocus = false
                    }
                    .onChange(of: sendSuccess) { _ in
                        proxy.scrollTo(scrollViewBottom, anchor: .bottom)
                    }
                }
                ChattingBarView(text: $inputText, imagePickerModel: imagePickerModel, isFocus: $isFocus) {
                    sendButtonAction()
                }
            }
            
        }
    }
}

#Preview {
    ChattingView(inputText: .constant(""), chatList: [], imagePickerModel: .init(maxSize: 44, imageData: []), sendSuccess: .constant(false)) {
        
    }
}
