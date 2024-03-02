//
//  CoinShopViewModel.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/29.
//

import Foundation
import Combine
import iamport_ios
import WebKit

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
        var toast: Toast? = nil
    }
    
    lazy var wkWebView: WKWebView = {
        var view = WKWebView()
        view.backgroundColor = UIColor.clear
        return view
     }()
    
    @Published var state: CoinShopState = .init()
    let profileRepository: ProfileRepository
    let appState: AppState
    var userCode: String {
        guard let secretUsecode = Bundle.main.infoDictionary?["IAMPORT_USERCODE"] as? String else { fatalError() }
        return secretUsecode
    }
    var coin: CoinItemModel?
    var iamportResponse: IamportResponse?
    private var cancellable = Set<AnyCancellable>()
    
    init(appState: AppState, profileRepository: ProfileRepository) {
        self.profileRepository = profileRepository
        self.appState = appState
        appStateBind()
    }
    
    private func appStateBind() {
        appState.$userData
            .receive(on: RunLoop.main)
            .sink { userData in
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
            self.coin = coin
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
    
    func createPatmentData() -> IamportPayment? {
        guard let sesacKey = Bundle.main.infoDictionary?["SESAC_APP_KEY"] as? String else { fatalError() }
        guard let coin else { return nil }
        let payment = IamportPayment(pg: PG.html5_inicis.makePgRawName(pgId: "INIpayTest"), merchant_uid: "ios_\(sesacKey)_\(Int(Date().timeIntervalSince1970))", amount: coin.price).then {
            $0.pay_method = PayMethod.card.rawValue
            $0.name = coin.name
            $0.buyer_name = appState.userData.nickname
            $0.app_scheme = "sesac"
        }
        return payment
    }
    
    func iamportCallBack(_ response: IamportResponse?) {
        if let res = response {
            print("Iamport response: \(res)")
            guard let impUid = res.imp_uid, let merchantUid = res.merchant_uid else { return }
            Task {
                do {
                    let paymentInfo = try await profileRepository.checkPurchase(.init(impUid: impUid, merchantUid: merchantUid))
                    appState.userData.sesacCoin += paymentInfo.sesacCoin
                    DispatchQueue.main.async {
                        self.state.toast = .init(message: "\(paymentInfo.sesacCoin)개 결제 완료", duration: 1.0)
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.state.toast = .init(message: "결제에 실패했습니다. 다시 시도해주십시오.", duration: 1.0)
                    }
                }
                
            }
        }
        iamportResponse = response
        
    }
}
