//
//  CreateChannelView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/23.
//

import SwiftUI

struct CreateChannelView: View {
    @Binding var isPresenting: Bool
    @State private var channelName: String = ""
    @State private var channelDescription: String = ""
    @ObservedObject var viewModel: ChatListViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 24) {
                    TitleTextField(title: "채널 이름", isValid: .constant(true), placeHolder: "채널 이름을 입력하세요(필수)", kind: .textField, textFieldTitle: $channelName)
                    TitleTextField(title: "채널 설명", isValid: .constant(true), placeHolder: "채널 을 설명하세요(옵션)", kind: .textField, textFieldTitle: $channelDescription)
                    Spacer()
                }
                .padding(24)
                
                VStack {
                    Spacer()
                    KeyboardStickeyButton(isFocus: .constant(false), title: "생성", isEnable: .constant(!channelName.isEmpty)) {
                        viewModel.trigger(.createChannel(name: channelName, description: channelDescription))
                    }
                }
            }
            .defaultBackground()
            .underlineNavigationBar(title: "채널 생성")
            .singleToastView(toast: $viewModel.state.toast)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        isPresenting = false
                    }, label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.black)
                    })
                }
            }
            .onChange(of: viewModel.state.successCreateChannel) { value in
                isPresenting = !value
            }
        }
    }
}
