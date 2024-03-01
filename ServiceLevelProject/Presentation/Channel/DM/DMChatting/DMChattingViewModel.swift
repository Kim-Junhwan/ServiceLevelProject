//
//  DMChattingViewModel.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/29.
//

import Foundation

final class DMChattingViewModel: ViewModel, ObservableObject {
    enum DMChattingInput {
        case sendChatting
        case onAppear
        case dismissView
    }
    
    struct DMChattingState {
        var DMBarText: String = ""
        var userInfo: UserThumbnailModel
        var chattingList: [ChattingMessageModel] = []
    }
    
    @Published var state: DMChattingState
    @Published var imageModel: MultipleImagePickerModel = .init(maxSize: 44, imageData: [])
    private var roomId: Int?
    private let fetchEnterDMChattingUsecase: FetchEnterDMChatListUsecase
    private let sendDMChattingUsecase: SendDMChattingUsecase
    private let appState: AppState
    
    init(appState: AppState ,fetchEnterDMChattingUsecase: FetchEnterDMChatListUsecase, sendDMChattingUsecase: SendDMChattingUsecase, user: UserThumbnailModel) {
        self.appState = appState
        self.state = .init(userInfo: user)
        self.fetchEnterDMChattingUsecase = fetchEnterDMChattingUsecase
        self.sendDMChattingUsecase = sendDMChattingUsecase
    }
    
    func trigger(_ input: DMChattingInput) {
        switch input {
        case .sendChatting:
            break
        case .onAppear:
            fetchDM()
        case .dismissView:
            break
        }
    }
    
    func fetchDM() {
        guard let workspacId = appState.currentWorkspace?.id else { return }
        Task {
            do {
                let value = try await fetchEnterDMChattingUsecase.excute(workspaceId: workspacId, audienceId: state.userInfo.id)
                self.roomId = value.roomId
                self.state.chattingList = value.chats.map { .init(chatId: $0.dmId, content: $0.content, createdAt: $0.createdAt, files: $0.files, user: .init(userThumnail: $0.user)) }
            }
        }
    }
}
