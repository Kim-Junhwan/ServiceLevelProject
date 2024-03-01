//
//  DMViewModel.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/26.
//

import Foundation
import Combine

final class DMViewModel: ViewModel, ObservableObject {
    enum DMViewModelInput {
        case appearView
    }
    
    struct DMViewModelState {
        var workspaceMembers: [UserThumbnailModel] = []
        var dmRooms: [DMRoomItemModel] = []
    }
    
    @Published var state: DMViewModelState = .init()
    private let appState: AppState
    private let dmRepository: DirectMessageRepository
    private var cancellableBag = Set<AnyCancellable>()
    private let fetchDMRoomListUsecase: FetchDMRoomListUsecase
    
    init(appState: AppState, dmRepository: DirectMessageRepository, fetchDMRoomListUsecase: FetchDMRoomListUsecase) {
        self.appState = appState
        self.dmRepository = dmRepository
        self.fetchDMRoomListUsecase = fetchDMRoomListUsecase
        appStateBind()
    }
    
    private func appStateBind() {
        appState.$selectWorkspace
            .receive(on: RunLoop.main)
            .sink { detailInfo in
                self.state.workspaceMembers = detailInfo?.workspaceMembers.filter{ $0.id != self.appState.userData.id }.map{ UserThumbnailModel(userThumnail: $0) } ?? []
        }
        .store(in: &cancellableBag)
    }
    
    func trigger(_ input: DMViewModelInput) {
        switch input {
        case .appearView:
            fetchDMRoom()
        }
    }
    
    private func fetchDMRoom() {
        guard let workspaceId = appState.currentWorkspace?.id else {return}
        Task {
            do {
                let value = try await fetchDMRoomListUsecase.excute(workspaceId: workspaceId)
                DispatchQueue.main.async {
                    print(value)
                    self.state.dmRooms = value.map{ .init(dm: $0, thumbnailContent: $1, newMessageCount: $2) }
                }
            }
        }
    }
}
