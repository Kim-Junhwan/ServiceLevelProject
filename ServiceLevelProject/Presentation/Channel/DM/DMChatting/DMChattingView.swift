//
//  DMChattingView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/29.
//

import SwiftUI

struct DMChattingView: View {
    @StateObject var viewModel: DMChattingViewModel
    
    init(selectUser: UserThumbnailModel) {
        self._viewModel = StateObject(wrappedValue: SharedAssembler.shared.resolve(DMChattingViewModel.self, argument: selectUser))
    }
    
    var body: some View {
        ChattingView(inputText: $viewModel.state.dMBarText, chatList: viewModel.state.chattingList, imagePickerModel: viewModel.imageModel, sendSuccess: $viewModel.state.successSend) {
            viewModel.trigger(.sendChatting)
        }
        .onAppear {
            viewModel.trigger(.onAppear)
        }
        .onDisappear {
            viewModel.trigger(.dismissView)
        }
        .underlineNavigationBar(title: viewModel.state.user.nickname)
    }
}

#Preview {
    DMChattingView(selectUser: .init(userThumnail: .init(id: 0, email: "123", nickname: "123", profileImagePath: nil)))
}
