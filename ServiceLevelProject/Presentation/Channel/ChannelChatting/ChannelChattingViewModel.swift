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
    }
    @Published var imageModel: MultipleImagePickerModel = .init(maxSize: 44, imageData: [])
    @Published var state: ChannelChattingState = .init()
    private var channelThumbnail: ChannelListItemModel
    let appState: AppState
    let channelRepository: ChannelRepository
    let chattingRepository: ChattingRepository
    let sendChannelChattingUsecase: SendChattingUseCase
    let socketManager: SocketIOManager
    private var cancellableBag = Set<AnyCancellable>()
    
    init(appState: AppState, channelThumbnail: ChannelListItemModel, channelRepository: ChannelRepository, sendChannelChattingUsecase: SendChattingUseCase, chattingRepository: ChattingRepository) {
        self.appState = appState
        self.channelThumbnail = channelThumbnail
        self.channelRepository = channelRepository
        self.sendChannelChattingUsecase = sendChannelChattingUsecase
        self.chattingRepository = chattingRepository
        self.socketManager = SocketIOManager(id: channelThumbnail.id, type: .channel)
        socketManager.messageSubject.sink { chatting in
            if chatting.user.id == appState.userData.id {
                return
            }
            Task {
                do {
                    try await chattingRepository.saveChannelChatting([chatting])
                    DispatchQueue.main.async {
                        self.state.chattingList.append(.init(chatId: chatting.chatId, content: chatting.content, createdAt: chatting.createdAt, files: chatting.files, user: .init(userThumnail: chatting.user)))
                    }
                }
                
            }
        }
        .store(in: &cancellableBag)
    }
    
    func trigger(_ input: ChannelChattingInput) {
        switch input {
        case .sendChatting:
            sendChatting()
        case .onAppear:
            fetchChannelInfo()
        case .dismissView:
            break
        }
    }
    
    private func fetchChannelInfo() {
        Task {
            let dbChattingList = await chattingRepository.fetchChannelChatting(.init(channelId: channelThumbnail.id, cursorDate: Date()))
            DispatchQueue.main.async {
                let presentationModel: [ChattingMessageModel] = dbChattingList.map { .init(chatId: $0.chatId, content: $0.content, createdAt: $0.createdAt, files: $0.files, user: .init(userThumnail: $0.user)) }
                self.state.chattingList.append(contentsOf: presentationModel)
            }
            do {
                let lastDate = dbChattingList.sorted(by: { $0.createdAt < $1.createdAt }).last?.createdAt ?? Date()
                print(dbChattingList)
                print(lastDate)
                let workspaceId = channelThumbnail.workspaceId
                let fetchChattingList = try await channelRepository.fetchChannelChatting(.init(workspaceId: workspaceId, channelName: channelThumbnail.name, cursorDate: lastDate))
                let detailChannelInfo = try await channelRepository.fetchDetailChannel(.init(channelName: channelThumbnail.name, workspaceId: workspaceId))
                try await chattingRepository.saveChannelChatting(fetchChattingList)
                DispatchQueue.main.async {
                    self.state.detailChannelInfo = .init(detailChannelInfo)
                    self.state.chattingList.append(contentsOf: fetchChattingList.map{ .init(chatId: $0.chatId, content: $0.content, createdAt: $0.createdAt, files: $0.files, user: .init(userThumnail: $0.user)) })
                }
            } catch {
                print(error)
            }
            self.socketManager.connectSocket()
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
                self.socketManager.sendMessage(channelChatting: .init(channelId: postChatting.channelId, channelName: postChatting.channelName, chatId: postChatting.chatId, content: postChatting.content, createdAt: postChatting.createdAt.description, files: postChatting.files, user: .init(userId: postChatting.user.id, email: postChatting.user.email, nickname: postChatting.user.nickname, profileImage: postChatting.user.profileImagePath)))
                DispatchQueue.main.async {
                    self.state.chattingList.append(.init(chatId: postChatting.chatId, content: postChatting.content, createdAt: postChatting.createdAt, files: postChatting.files, user: .init(userThumnail: postChatting.user)))
                }
            }
        }
    }
}
