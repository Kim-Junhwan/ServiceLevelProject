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
        ChattingView(inputText: $viewModel.state.dMBarText, chatList: viewModel.state.chattingList, imagePickerModel: viewModel.imageModel) {
            viewModel.trigger(.sendChatting)
        }
        .onAppear {
            viewModel.trigger(.onAppear)
        }
        .underlineNavigationBar(title: viewModel.state.userInfo.nickname)
    }
}

#Preview {
    DMChattingView(selectUser: .init(userThumnail: .init(id: 0, email: "123", nickname: "123", profileImagePath: nil)))
}
