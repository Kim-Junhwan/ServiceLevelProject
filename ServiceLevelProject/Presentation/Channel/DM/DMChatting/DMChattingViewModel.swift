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
        var user: UserThumbnailModel
        var chattingList: [ChattingMessageModel] = []
    }
    
    @Published var state: DMChattingState
    @Published var imageModel: MultipleImagePickerModel = .init(maxSize: 44, imageData: [])
    private let fetchEnterDMChattingUsecase: FetchEnterDMChatListUsecase
    private let sendDMChattingUsecase: SendDMChattingUsecase
    private let appState: AppState
    private var socketManager: DMSocketIOManager?
    private var roomId: Int?
    private var cancellableBag = Set<AnyCancellable>()
    
    init(appState: AppState ,fetchEnterDMChattingUsecase: FetchEnterDMChatListUsecase, sendDMChattingUsecase: SendDMChattingUsecase, user: UserThumbnailModel) {
        self.appState = appState
        self.state = .init(user: user)
        self.fetchEnterDMChattingUsecase = fetchEnterDMChattingUsecase
        self.sendDMChattingUsecase = sendDMChattingUsecase
    }
    
    func trigger(_ input: DMChattingInput) {
        switch input {
        case .sendChatting:
            sendChatting()
        case .onAppear:
            fetchDM()
        case .dismissView:
            dismissView()
        }
    }
    
    private func socketInital(roomId: Int) {
        socketManager = DMSocketIOManager(id: roomId)
        socketManager?.connectSocket()
        socketManager?.chattingSubject
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { chattingList in
                self.applyChatting(chattingList: chattingList, roomId: roomId)
            })
            .store(in: &cancellableBag)
    }
    
    private func applyChatting(chattingList: [DMChatting], roomId: Int) {
        guard let workspaceId = appState.currentWorkspace?.id else { return }
        Task {
            do {
                try await sendDMChattingUsecase.saveChatting(roomId: roomId, workspaceId: workspaceId, chatting: chattingList)
                DispatchQueue.main.async {
                    self.state.chattingList = chattingList.map { .init(chatId: $0.dmId, content: $0.content, createdAt: $0.createdAt, files: $0.files, user: .init(userThumnail: $0.user)) }
                }
            } catch {
                print(error)
            }
        }
    }
    
    private func fetchDM() {
        guard let workspacId = appState.currentWorkspace?.id else { return }
        Task {
            do {
                let value = try await fetchEnterDMChattingUsecase.excute(workspaceId: workspacId, audienceId: state.user.id)
                self.roomId = value.roomId
                applyChatting(chattingList: value.chats, roomId: value.roomId)
                if !state.chattingList.isEmpty {
                    socketInital(roomId: value.roomId)
                }
            }
        }
    }
    
    private func sendChatting() {
        guard let workspaceId = appState.currentWorkspace?.id else { return }
        guard let roomId else { return }
        let imageData = imageModel.imageData.compactMap({ $0 })
        let dmText = state.dMBarText
        if socketManager == nil {
            socketInital(roomId: roomId)
        }
        Task {
            do {
                let sendChatting = try await sendDMChattingUsecase.excute(roomId: roomId, workspaceId: workspaceId, content: state.dMBarText.isEmpty ? "" : dmText, files: imageData)
                socketManager?.emit(chatting: sendChatting)
                applyChatting(chattingList: [sendChatting], roomId: roomId)
                await imageModel.removeAll()
            }
        }
    }
    
    private func dismissView() {
        socketManager?.closeSocket()
        socketManager = nil
    }
}
