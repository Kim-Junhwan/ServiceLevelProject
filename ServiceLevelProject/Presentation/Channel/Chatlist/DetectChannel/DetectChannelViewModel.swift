//
//  DetectChannelViewModel.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/25.
//

import SwiftUI

final class DetectChannelViewModel: ViewModel, ObservableObject {
    enum DetectChannelViewModelInput {
        case appearView
        case tapChannel(ChannelListItemModel)
    }
    
    struct DetectChanneViewModelState {
        var channelList: [ChannelListItemModel] = []
        var alertEnterChannel: AlertMessage?
    }
    
    @Published var state: DetectChanneViewModelState = .init()
    private let appState: AppState
    private let channelRepository: ChannelRepository
    private var comeInChannelList: [ChannelListItemModel] = []
    
    init(appState: AppState, channelRepository: ChannelRepository) {
        self.appState = appState
        self.channelRepository = channelRepository
    }
    
    func trigger(_ input: DetectChannelViewModelInput) {
        switch input {
        case .appearView:
            fetchChannelList()
        case .tapChannel(let channel):
            enterChannel(channel: channel)
        }
    }
    
    private func fetchChannelList() {
        guard let workspaceId = appState.selectWorkspace?.workspaceId else { return }
        Task {
            let value = try await channelRepository.fetchWorkspaceChannel(.init(workspaceId: workspaceId))
            let comeInChannelList = try await channelRepository.fetchComeInChannel(.init(workspaceId: workspaceId))
            self.comeInChannelList = comeInChannelList.map{ .init(channelList: $0) }
            DispatchQueue.main.async {
                self.state.channelList = value.map{ .init(channelList: $0) }
            }
        }
    }
    
    private func enterChannel(channel: ChannelListItemModel) {
        if comeInChannelList.contains(where: { $0.id == channel.id }) {
            
        } else {
            state.alertEnterChannel = .init(title: "채널 참여", description: "[\(channel.name)] 채널에 참여하시겠습니까?", type: .cancelOk(cancelTitle: "취소", okTitle: "확인"), action: {
                
            })
        }
    }
}
