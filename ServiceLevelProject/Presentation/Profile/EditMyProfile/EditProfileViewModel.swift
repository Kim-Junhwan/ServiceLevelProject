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
        case editNickname(String)
        case editPhoneNumber(String)
        case onAppear
    }
    
    struct EditProfileViewState {
        var sesacCoin: Int
        var nickname: String
        var phoneNumber: String?
        var email: String
        var toast: Toast?
        let vendor: LoginPlatform
        var nicknameEditingSuccess: Bool = false
        var phoneEditingSuccess: Bool = false
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
        imageModel.action = { result in
            switch result {
            case .success(let data):
                if let imageData = data {
                    self.editProfileImage(imageData: imageData)
                }
            case .failure(_):
                print("Fail")
            }
        }
        bind()
    }
    
    func trigger(_ input: EditProfileInput) {
        switch input {
        case .logout:
            appState.logout()
        case .onAppear:
            fetchMyProfile()
        case .editNickname(let nickname):
            editNickname(nickName: nickname)
        case .editPhoneNumber(let phoneNumber):
            editPhone(phoneNumber: phoneNumber)
        }
    }
    
    func bind() {
        appStateBind()
    }
    
    private func appStateBind() {
        appState.$userData
            .receive(on: RunLoop.main)
            .sink { userData in
                self.state.nickname = userData.nickname
                self.state.email = userData.email
                self.imageModel.url = userData.profileImagePath
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
    
    private func editNickname(nickName: String) {
        Task {
            let userProfile = try await profileRepository.editProfile(.init(nickname: nickName, phone: state.phoneNumber))
            appState.setUserData(userProfile)
            DispatchQueue.main.async {
                self.state.nicknameEditingSuccess = true
            }
        }
    }
    
    private func editPhone(phoneNumber: String) {
        Task {
            let userProfile = try await profileRepository.editProfile(.init(nickname: state.nickname, phone: phoneNumber))
            appState.setUserData(userProfile)
            DispatchQueue.main.async {
                self.state.phoneEditingSuccess = true
            }
        }
    }
    
    private func editProfileImage(imageData: Data) {
        Task {
            let userProfile = try await profileRepository.editProfileImage(imageData: imageData)
            appState.setUserData(userProfile)
            DispatchQueue.main.async {
                self.state.toast = .init(message: "프로필 이미지가 성공적으로 변경되었습니다.", duration: 1.0)
            }
        }
    }
}
