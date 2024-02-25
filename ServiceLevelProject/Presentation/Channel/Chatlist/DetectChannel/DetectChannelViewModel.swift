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
    }
    
    struct DetectChanneViewModelState {
        var channelList: [ChannelListItemModel] = []
    }
    
    @Published var state: DetectChanneViewModelState = .init()
    private let appState: AppState
    private let channelRepository: ChannelRepository
    
    init(appState: AppState, channelRepository: ChannelRepository) {
        self.appState = appState
        self.channelRepository = channelRepository
    }
    
    func trigger(_ input: DetectChannelViewModelInput) {
        switch input {
        case .appearView:
            fetchChannelList()
        }
    }
    
    private func fetchChannelList() {
        guard let workspaceId = appState.selectWorkspace?.workspaceId else { return }
        Task {
            let value = try await channelRepository.fetchWorkspaceChannel(.init(workspaceId: workspaceId))
            DispatchQueue.main.async {
                self.state.channelList = value.map{ .init(channelList: $0) }
            }
        }
    }
}
