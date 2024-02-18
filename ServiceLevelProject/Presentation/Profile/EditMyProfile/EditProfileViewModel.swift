//
//  EditProfileViewModel.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/15.
//

import Foundation

final class EditProfileViewModel: ViewModel {
    
    enum EditProfileInput {
        case logout
        case onAppear
    }
    
    struct EditProfileViewState {
        var sessacCoin: Int
        var nickname: String
        var phoneNumber: String
        var email: String
        var vendor: LoginType
    }
    
    @Published var imageModel: ImagePickerModel
    @Published var state: EditProfileViewState
    private let appState: AppState
    
    init(appState: AppState, imageData: Data?) {
        self.state = EditProfileViewState(sessacCoin: 0, nickname: appState.userData.nickname, phoneNumber: appState.userData.phone ?? "", email: appState.userData.email, vendor: .kakao)
        self.imageModel = ImagePickerModel(maxSize: 70, imageData: imageData)
        self.appState = appState
    }
    
    func trigger(_ input: EditProfileInput) {
        switch input {
        case .logout:
            appState.logout()
        case .onAppear:
            fetchMyProfile()
        }
    }
    
    private func fetchMyProfile() {
        
    }
}
