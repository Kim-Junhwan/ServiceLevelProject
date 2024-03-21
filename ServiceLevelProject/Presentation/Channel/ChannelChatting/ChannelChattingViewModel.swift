//
//  ChannelChattingViewModel.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/28.
//

import Combine
import Foundation
import SocketIO

final class ChannelChattingViewModel: ViewModel, ObservableObject {
    enum ChannelChattingInput {
        case sendChatting
        case onAppear
        case dismissView
    }
    
    struct ChannelChattingState {
        var chattingBarText: String = ""
        var detailChannelInfo: DetailChannelInfoModel?
        var chattingList: [ChattingMessageModel] = []
        var successSend: Bool = false
    }
    @Published var imageModel: MultipleImagePickerModel = .init(maxSize: 44, imageData: [])
    @Published var state: ChannelChattingState = .init()
    private var channelThumbnail: ChannelListItemModel
    private let appState: AppState
    private let channelRepository: ChannelRepository
    private let chattingRepository: ChattingRepository
    private let sendChannelChattingUsecase: SendChattingUseCase
    private let fetchChannelChatList: FetchEnterChannelChatListUsecase
    private var cancellableBag = Set<AnyCancellable>()
    private var socketManager: ChannelSocketIOManager?
    
    init(appState: AppState, channelThumbnail: ChannelListItemModel, channelRepository: ChannelRepository, sendChannelChattingUsecase: SendChattingUseCase, chattingRepository: ChattingRepository, fetchChannelChatList: FetchEnterChannelChatListUsecase) {
        self.appState = appState
        self.channelThumbnail = channelThumbnail
        self.channelRepository = channelRepository
        self.sendChannelChattingUsecase = sendChannelChattingUsecase
        self.chattingRepository = chattingRepository
        self.fetchChannelChatList = fetchChannelChatList
    }
    
    func trigger(_ input: ChannelChattingInput) {
        switch input {
        case .sendChatting:
            sendChatting()
        case .onAppear:
            fetchChannelInfo()
        case .dismissView:
            closeSocket()
        }
    }
    
    private func socketInital() {
        socketManager = ChannelSocketIOManager(id: channelThumbnail.id)
        socketManager?.connectSocket()
        socketManager?.chattingSubject
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { chattingList in
                self.applyChatting(chattingList: [chattingList])
            })
            .store(in: &cancellableBag)
    }
    
    private func fetchChannelInfo() {
        Task {
            do {
                let chattingList = try await self.fetchChannelChatList.excute(channelItem: self.channelThumbnail)
                DispatchQueue.main.async {
                    self.state.detailChannelInfo = .init(chattingList.1)
                }
                socketInital()
                applyChatting(chattingList: chattingList.0)
            } catch {
                print(error)
            }
        }
    }
    
    private func applyChatting(chattingList: [ChannelChatting]) {
        DispatchQueue.main.async {
            self.state.chattingList = chattingList.map { .init(chatId: $0.chatId, content: $0.content, createdAt: $0.createdAt, files: $0.files, user: .init(userThumnail: $0.user)) }
        }
    }
    
    private func sendChatting() {
        guard let channelInfo = state.detailChannelInfo else { return }
        guard let workspaceId = channelInfo.workspaceId else { return }
        let imageData = imageModel.imageData.compactMap({ $0 })
        let chattingBarText = state.chattingBarText
        state.chattingBarText = ""
        Task {
            await imageModel.removeAll()
            do {
                let postChatting = try await sendChannelChattingUsecase.excute(channelName: channelInfo.name, workspaceId: workspaceId, content: chattingBarText, files: imageData)
                socketManager?.emit(chatting: postChatting)
                applyChatting(chattingList: [postChatting])
            }
        }
    }
    
    private func closeSocket() {
        socketManager?.closeSocket()
        socketManager = nil
    }
}
