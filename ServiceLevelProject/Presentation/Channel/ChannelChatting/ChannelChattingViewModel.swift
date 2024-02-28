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
    }
    @Published var imageModel: MultipleImagePickerModel = .init(maxSize: 44, imageData: [])
    @Published var state: ChannelChattingState = .init()
    private var channelThumbnail: ChannelListItemModel
    let appState: AppState
    let channelRepository: ChannelRepository
    
    init(appState: AppState, channelThumbnail: ChannelListItemModel, channelRepository: ChannelRepository) {
        self.appState = appState
        self.channelThumbnail = channelThumbnail
        self.channelRepository = channelRepository
    }
    
    func trigger(_ input: ChannelChattingInput) {
        switch input {
        case .sendChatting:
            break
        case .onAppear:
            fetchChannelInfo()
        case .dismissView:
            break
        }
    }
    
    private func fetchChannelInfo() {
        guard let workspaceId = appState.currentWorkspace?.id else { return }
        Task {
            do {
                let detailChannelInfo = try await channelRepository.fetchDetailChannel(.init(channelName: channelThumbnail.name, workspaceId: workspaceId))
                self.state.detailChannelInfo = .init(detailChannelInfo)
            } catch {
                print(error)
            }
            
        }
    }
}
