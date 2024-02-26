//
//  InviteMemberView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/26.
//

import SwiftUI

struct InviteMemberView: View {
    @Binding var isPresenting: Bool
    @StateObject var viewModel: InviteMemberViewModel = SharedAssembler.shared.resolve(InviteMemberViewModel.self)
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    TitleTextField(title: "이메일", isValid: .constant(true), placeHolder: "초대하려는 팀원의 이메일을 입력하세요", kind: .textField, textFieldTitle: $viewModel.state.email)
                    Spacer()
                }
                .underlineNavigationBar(title: "팀원 초대")
                .padding(24)
                .defaultBackground()
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            isPresenting = false
                        }, label: {
                            Image(systemName: "xmark")
                                .foregroundStyle(.black)
                        })
                    }
            }
                VStack {
                    Spacer()
                    KeyboardStickeyButton(isFocus: .constant(false), title: "초대 보내기", isEnable: .constant(!viewModel.state.email.isEmpty)) {
                        viewModel.trigger(.tapInviteButton)
                    }
                }
            }
            .onChange(of: viewModel.state.successInviteMember) { value in
                isPresenting = !value
            }
        }
        
    }
}

#Preview {
    InviteMemberView(isPresenting: .constant(true))
}
