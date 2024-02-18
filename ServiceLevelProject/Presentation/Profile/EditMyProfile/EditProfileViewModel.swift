//
//  EditProfileViewModel.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/15.
//

import Combine
import Foundation

final class EditProfileViewModel: ViewModel {
    
    enum EditProfileInput {
        case logout
        case onAppear
    }
    
    struct EditProfileViewState {
        var sesacCoin: Int
        var nickname: String
        var phoneNumber: String?
        var email: String
        var toast: Toast?
        let vendor: LoginPlatform
    }
    
    @Published var imageModel: ImagePickerModel = ImagePickerModel(maxSize: 70, imageData: nil)
    @Published var state: EditProfileViewState
    private let appState: AppState
    private let profileRepository: ProfileRepository
    private var cancellableBag = Set<AnyCancellable>()
    
    init(appState: AppState, profileRepository: ProfileRepository) {
        let userData = appState.userData
        self.state = EditProfileViewState(sesacCoin: userData.sesacCoin, nickname: userData.nickname, phoneNumber: userData.phone, email: userData.email, vendor: appState.loginInfo.loginType)
        self.appState = appState
        self.profileRepository = profileRepository
        appStateBind()
    }
    
    func trigger(_ input: EditProfileInput) {
        switch input {
        case .logout:
            appState.logout()
        case .onAppear:
            fetchMyProfile()
        }
    }
    
    func appStateBind() {
        appState.$userData
            .receive(on: RunLoop.main)
            .sink { userData in
                self.state.nickname = userData.nickname
                self.state.email = userData.email
                self.state.phoneNumber = userData.phone
                self.state.sesacCoin = userData.sesacCoin
            }
            .store(in: &cancellableBag)
    }
    
    private func fetchMyProfile() {
        Task {
            do {
                let userProfile = try await profileRepository.fetchMyProfile()
                appState.setUserData(userProfile)
            } catch {
                self.state.toast = .init(message: error.localizedDescription, duration: 1.0)
            }
        }
    }
}
