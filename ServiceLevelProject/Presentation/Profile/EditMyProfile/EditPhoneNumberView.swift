//
//  EditPhoneNumberView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/19.
//

import SwiftUI

struct EditPhoneNumberView: View {
    @State var phoneNumber: String
    @State private var originPhoneNumber: String
    @ObservedObject var viewModel: EditProfileViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(phoneNumber: String?, viewModel: EditProfileViewModel) {
        self._phoneNumber = State(initialValue: phoneNumber ?? "")
        self._originPhoneNumber = State(initialValue: phoneNumber ?? "")
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            VStack {
                TextField("전화번호를 입력하세요", text: $phoneNumber)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .padding(.leading, 12)
                    .background(RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.white))
                    .font(CustomFont.body.font)
                    .onChange(of: phoneNumber) { value in
                        var removeHypenNumber = value.components(separatedBy: ["-"]).joined()
                        if removeHypenNumber.count > 11 {
                            removeHypenNumber.removeLast()
                        }
                        originPhoneNumber = removeHypenNumber
                        self.phoneNumber = self.originPhoneNumber.phoneFormat()
                    }
                Spacer()
            }
            .padding(24)
            
            VStack {
                Spacer()
                KeyboardStickeyButton(isFocus: .constant(false), title: "완료", isEnable: .constant(Validator.isValid(category: .phoneNumber, phoneNumber))) {
                    viewModel.trigger(.editPhoneNumber(phoneNumber))
                }
            }
            .onChange(of: viewModel.state.phoneEditingSuccess) { value in
                if value {
                    dismiss()
                }
            }
        }
        .underlineNavigationBar(title: "연락처")
        .defaultBackground()
        
    }
}

#Preview {
    EditPhoneNumberView(phoneNumber: "", viewModel: EditProfileViewModel(appState: .init(), profileRepository: DefaultProfileRepository()))
}
