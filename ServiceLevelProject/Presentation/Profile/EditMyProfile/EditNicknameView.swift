//
//  EditNicknameView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/19.
//

import SwiftUI

struct EditNicknameView: View {
    @State var nickname: String
    @ObservedObject var viewModel: EditProfileViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(nickname: String, viewModel: EditProfileViewModel) {
        self._nickname = State(initialValue: nickname)
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            VStack {
                TextField("닉네임을 입력하세요", text: $nickname)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .padding(.leading, 12)
                    .background(RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.white))
                    .font(CustomFont.body.font)
                Spacer()
            }
            .padding(24)
            
            VStack {
                Spacer()
                KeyboardStickeyButton(isFocus: .constant(false), title: "완료", isEnable: .constant(Validator.isValid(category: .nick, nickname))) {
                    viewModel.trigger(.editNickname(nickname))
                }
            }
        }
        .underlineNavigationBar(title: "닉네임")
        .defaultBackground()
        .onChange(of: viewModel.state.nicknameEditingSuccess) { value in
            if value {
                dismiss()
            }
        }
    }
}

#Preview {
    EditNicknameView(nickname: "", viewModel: EditProfileViewModel(appState: .init(), profileRepository: DefaultProfileRepository()))
}
