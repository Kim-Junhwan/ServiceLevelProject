//
//  EditProfileView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/15.
//

import SwiftUI

struct EditProfileView: View {
    
    @StateObject private var viewModel: EditProfileViewModel
    
    init(imageData: Data?) {
        self._viewModel = StateObject(wrappedValue: SharedAssembler.shared.resolve(EditProfileViewModel.self, argument: imageData))
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
        .frame(maxHeight: .infinity)
        .padding(.top, 24)
        .background(.backgroundPrimary)
        .underlineNavigationBar(title: "내 정보 수정")
        .onAppear {
            viewModel.
        }
    }
    
    @ViewBuilder
    var editableProfileView: some View {
        VStack {
            ProfileCell(title: "내 새싹 코인", subTitle: "충전하기", decoratorType: .indicator) {
                Text("\(viewModel.state.sessacCoin)")
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
                
            }
            
            ProfileCell(title: "연락처", subTitle: viewModel.state.phoneNumber, decoratorType: .indicator) {
                EmptyView()
            } subView: {
                EmptyView()
            } action:  {
                
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
            
            ProfileCell(title: "연결된 소셜 계정", subTitle: viewModel.state.email, decoratorType: .none) {EmptyView()
            }subView: {
                EmptyView()
            }  action:  {
                
            }
            
            ProfileCell(title: "로그아웃", decoratorType: .none) {EmptyView()
            }subView: {
                EmptyView()
            }  action:  {
                viewModel.trigger(.logout)
            }
        }
        .background(.white)
        .clipShape(.rect(cornerRadius: 8))
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
    var decoratorView: some View {
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
        HStack {subView()
            Text(subTitle ?? "")
                .font(CustomFont.body.font)
                .foregroundStyle(.textSecondary)
            decoratorView
            
        }
    }
}

#Preview {
    EditProfileView(imageData: nil)
}
