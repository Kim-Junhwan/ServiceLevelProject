//
//  DMChattingViewModel.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/29.
//

import Combine
import Foundation

final class DMChattingViewModel: ViewModel, ObservableObject {
    enum DMChattingInput {
        case sendChatting
        case onAppear
        case dismissView
    }
    
    struct DMChattingState {
        var dMBarText: String = ""
        var successSend: Bool = false
        var userInfo: UserThumbnailModel
        var chattingList: [ChattingMessageModel] = []
    }
    
    @Published var state: DMChattingState
    @Published var imageModel: MultipleImagePickerModel = .init(maxSize: 44, imageData: [])
    private var roomId: Int?
    private let fetchEnterDMChattingUsecase: FetchEnterDMChatListUsecase
    private let sendDMChattingUsecase: SendDMChattingUsecase
    private let appState: AppState
    private var socketManager: SocketIOManager?
    private let chattingRepository: ChattingRepository
    private var cancellableBag = Set<AnyCancellable>()
    
    init(appState: AppState ,fetchEnterDMChattingUsecase: FetchEnterDMChatListUsecase, sendDMChattingUsecase: SendDMChattingUsecase, user: UserThumbnailModel, chattingRepository: ChattingRepository) {
        self.appState = appState
        self.state = .init(userInfo: user)
        self.fetchEnterDMChattingUsecase = fetchEnterDMChattingUsecase
        self.sendDMChattingUsecase = sendDMChattingUsecase
        self.chattingRepository = chattingRepository
    }
    
    func trigger(_ input: DMChattingInput) {
        switch input {
        case .sendChatting:
            sendChatting()
        case .onAppear:
            fetchDM()
        case .dismissView:
            break
        }
    }
    
    private func socketChattingBind() {
        socketManager?.dmMessageSubject
            .receive(on: RunLoop.main)
            .sink(receiveValue: { chatting in
                if chatting.user.id == self.appState.userData.id {
                    return
                }
                guard let workspacId = self.appState.currentWorkspace?.id else { return }
                guard let roomId = self.roomId else { return }
                Task {
                    do {
                        try await self.chattingRepository.saveDMChatting(.init(workspaceId: workspacId, roomId: roomId, chats: [chatting]))
                        DispatchQueue.main.async {
                            self.state.chattingList.append(.init(chatId: chatting.dmId, content: chatting.content, createdAt: chatting.createdAt, files: chatting.files, user: .init(userThumnail: chatting.user)))
                            self.state.successSend.toggle()
                        }
                    }
                }
                
            })
            .store(in: &cancellableBag)
    }
    
    private func fetchDM() {
        guard let workspacId = appState.currentWorkspace?.id else { return }
        Task {
            do {
                let value = try await fetchEnterDMChattingUsecase.excute(workspaceId: workspacId, audienceId: state.userInfo.id)
                self.roomId = value.roomId
                DispatchQueue.main.async {
                    self.state.chattingList = value.chats.map { .init(chatId: $0.dmId, content: $0.content, createdAt: $0.createdAt, files: $0.files, user: .init(userThumnail: $0.user)) }
                    self.state.successSend.toggle()
                }
                socketManager = .init(id: value.roomId, type: .dm)
                socketChattingBind()
                socketManager?.connectSocket()
            }
        }
    }
    
    private func sendChatting() {
        guard let roomId else { return }
        guard let workspaceId = appState.currentWorkspace?.id else { return }
        let imageData = imageModel.imageData.compactMap({ $0 })
        let dmText = state.dMBarText
        state.dMBarText = ""
        Task {
            do {
                let sendChatting = try await sendDMChattingUsecase.excute(roomId: roomId, workspaceId: workspaceId, content: state.dMBarText.isEmpty ? "" : dmText, files: imageData)
                DispatchQueue.main.async {
                    self.state.chattingList.append(.init(chatId: sendChatting.chatId, content: dmText, createdAt: sendChatting.createdAt, files: sendChatting.files, user: sendChatting.user))
                    self.state.successSend.toggle()
                }
                await imageModel.removeAll()
            }
        }
    }
}
