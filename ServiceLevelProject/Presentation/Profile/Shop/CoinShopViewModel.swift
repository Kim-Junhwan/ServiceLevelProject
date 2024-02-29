//
//  CoinShopViewModel.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/29.
//

import Foundation
import Combine

struct CoinItemModel: Identifiable {
    let id: UUID = .init()
    let name: String
    let price: String
}

class CoinShopViewModel: ViewModel, ObservableObject {
    enum CoinShopInput {
        case appearView
        case tapBuyButton(CoinItemModel)
    }
    
    struct CoinShopState {
        var coinList: [CoinItemModel] = []
        var hasCoin: Int = 0
    }
    
    @Published var state: CoinShopState = .init()
    let profileRepository: ProfileRepository
    let appState: AppState
    private var cancellable = Set<AnyCancellable>()
    
    init(appState: AppState, profileRepository: ProfileRepository) {
        self.profileRepository = profileRepository
        self.appState = appState
        appStateBind()
    }
    
    private func appStateBind() {
        appState.$userData.sink { userData in
            self.state.hasCoin = userData.sesacCoin
        }
        .store(in: &cancellable)
    }
    
    func trigger(_ input: CoinShopInput) {
        switch input {
        case .appearView:
            fetchCoinList()
            fetchMyProfile()
        case .tapBuyButton(let coin):
            buyCoin(coin: coin)
        }
    }
    
    private func fetchCoinList() {
        Task {
            do {
                let cointList = try await profileRepository.fetchCoinList()
                DispatchQueue.main.async {
                    self.state.coinList = cointList.map { .init(name: $0.item, price: $0.amount) }
                }
            }
        }
    }
    
    private func fetchMyProfile() {
        Task {
            do {
                let userProfile = try await profileRepository.fetchMyProfile()
                appState.setUserData(userProfile)
            }
        }
    }
    
    func buyCoin(coin: CoinItemModel) {
        print(coin)
    }
}
