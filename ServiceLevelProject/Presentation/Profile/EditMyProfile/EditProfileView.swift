//
//  EditProfileView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/15.
//

import SwiftUI

struct EditProfileView: View {
    
    @StateObject private var viewModel: EditProfileViewModel
    @State private var alert: AlertMessage? = nil
    @State private var showEditNickname: Bool = false
    @State private var showEditPhoneNumber: Bool = false
    
    init(imageData: Data?) {
        self._viewModel = StateObject(wrappedValue: SharedAssembler.shared.resolve(EditProfileViewModel.self))
    }
    
    var body: some View {
        VStack {
            ImagePickerView(viewModel: viewModel.imageModel)
                .padding(.top, 24)
            VStack {
                editableProfileView
                userInfoView
            }
            .padding([.leading, .trailing], 23)
            .padding(.top, 35)
            Spacer()
        }
        .toastView(toast: $viewModel.state.toast)
        .frame(maxHeight: .infinity)
        .padding(.top, 24)
        .background(.backgroundPrimary)
        .underlineNavigationBar(title: "내 정보 수정")
        .customAlert(alertMessage: $alert)
        .navigationDestination(isPresented: $showEditNickname, destination: {
            EditNicknameView(nickname: viewModel.state.nickname, viewModel: viewModel)
        })
        .navigationDestination(isPresented: $showEditPhoneNumber, destination: {
            EditPhoneNumberView(phoneNumber: viewModel.state.phoneNumber, viewModel: viewModel)
        })
        .onAppear {
            viewModel.trigger(.onAppear)
        }
    }
    
    @ViewBuilder
    var editableProfileView: some View {
        VStack {
            ProfileCell(title: "내 새싹 코인", subTitle: "충전하기", decoratorType: .indicator) {
                Text("\(viewModel.state.sesacCoin)")
                    .font(CustomFont.bodyBold.font)
                    .foregroundStyle(.brandGreen)
            } subView: {
                EmptyView()
            } action: {
                
            }
            
            ProfileCell(title: "닉네임", subTitle: viewModel.state.nickname, decoratorType: .indicator) {
                EmptyView()
            } subView: {EmptyView()
            } action: {
                showEditNickname = true
            }
            ProfileCell(title: "연락처", subTitle: viewModel.state.phoneNumber, decoratorType: .indicator) {
                EmptyView()
            } subView: {
                EmptyView()
            } action:  {
                showEditPhoneNumber = true
            }
        }
        .background(.white)
        .clipShape(.rect(cornerRadius: 8))
        .padding(.bottom, 16)
    }
    
    @ViewBuilder
    var userInfoView: some View {
        VStack {
            ProfileCell(title: "이메일", subTitle: viewModel.state.email, decoratorType: .none) {EmptyView()
            }subView: {
                EmptyView()
            }  action:  {
                
            }
            .disabled(true)
            socialCell()
                .disabled(true)
            ProfileCell(title: "로그아웃", decoratorType: .none) {EmptyView()
            }subView: {
                EmptyView()
            }  action:  {
                alert = .init(title: "로그아웃", description: "정말 로그아웃 할까요?", type: .cancelOk(cancelTitle: "취소", okTitle: "로그아웃"), action: {
                    viewModel.trigger(.logout)
                })
            }
        }
        .background(.white)
        .clipShape(.rect(cornerRadius: 8))
    }
    
    func socialCell() -> some View {
        if viewModel.state.vendor == .apple(idToken: "") || viewModel.state.vendor == .kakao(oauthToken: "") {
            return AnyView(ProfileCell(title: "연결된 소셜 계정", subTitle: nil, decoratorType: .none) {EmptyView()
            }subView: {
                socialImageView()
                    .clipShape(.circle)
            }  action:  {})
        }
        return AnyView(EmptyView())
    }
    
    func socialImageView() -> some View {
        switch viewModel.state.vendor {
        case .kakao:
            return AnyView(Image(.kakaoLogo)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 10, height: 10)
                .frame(width: 20, height: 20)
                .background(.kakaoYellow)
            )
        case .apple:
            return AnyView(Image(.appleLogo)
                .resizable().aspectRatio(contentMode: .fill)
                .frame(width: 9, height: 11)
                .frame(width: 20, height: 20)
                .background(.appleBlack)
            )
        default:
            return AnyView(EmptyView())
        }
    }
}

struct ProfileCell<Content: View, SideView: View>: View {
    
    enum DecoratorType {
        case none
        case indicator
    }
    
    let title: String
    var subTitle: String?
    let decoratorType: DecoratorType
    let contentView: () -> Content
    var subView: () -> SideView
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            HStack {
                Text(title)
                    .font(CustomFont.bodyBold.font)
                    .foregroundStyle(.black)
                contentView()
                Spacer()
                rightView
            }
            .padding(15)
            .frame(height: 44)
        })
        .listRowSeparator(.hidden)
    }
    
    @ViewBuilder
    func decoratorView() -> some View {
        switch decoratorType {
        case .none:
            EmptyView()
        case .indicator:
            Image(systemName: "chevron.right")
                .resizable()
                .frame(width: 6.5, height: 13)
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(.textSecondary)
        }
    }
    
    @ViewBuilder
    var rightView: some View {
        HStack {
            subView()
            if let subTitle {
                Text(subTitle)
                    .font(CustomFont.body.font)
                    .foregroundStyle(.textSecondary)
            }
            decoratorView()
        }
    }
}

#Preview {
    EditProfileView(imageData: nil)
}
