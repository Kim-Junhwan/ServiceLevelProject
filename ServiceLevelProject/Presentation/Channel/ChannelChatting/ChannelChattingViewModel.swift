//
//  ChannelChattingViewModel.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/28.
//

import Foundation

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
    
    init(appState: AppState, channelThumbnail: ChannelListItemModel, channelRepository: ChannelRepository, sendChannelChattingUsecase: SendChattingUseCase, chattingRepository: ChattingRepository) {
        self.appState = appState
        self.channelThumbnail = channelThumbnail
        self.channelRepository = channelRepository
        self.sendChannelChattingUsecase = sendChannelChattingUsecase
        self.chattingRepository = chattingRepository
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
        guard let workspaceId = appState.currentWorkspace?.id else { return }
        Task {
            let value = await chattingRepository.fetchChannelChatting(.init(channelId: channelThumbnail.id, cursorDate: Date()))
            DispatchQueue.main.async {
                let presentationModel: [ChattingMessageModel] = value.map { .init(chatId: $0.chatId, content: $0.content, createdAt: $0.createdAt, files: $0.files, user: .init(userThumnail: $0.user)) }
                self.state.chattingList.append(contentsOf: presentationModel)
            }
            do {
                let detailChannelInfo = try await channelRepository.fetchDetailChannel(.init(channelName: channelThumbnail.name, workspaceId: workspaceId))
                DispatchQueue.main.async {
                    self.state.detailChannelInfo = .init(detailChannelInfo)
                }
            } catch {
                print(error)
            }
            
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
                DispatchQueue.main.async {
                    self.state.chattingList.append(.init(chatId: postChatting.chatId, content: postChatting.content, createdAt: postChatting.createdAt, files: postChatting.files, user: .init(userThumnail: postChatting.user)))
                }
            }
        }
    }
}
