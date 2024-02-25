//
//  WorkspaceAdminView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/15.
//

import SwiftUI

struct WorkspaceChangeAdminView: View {
    @Binding var isPresenting: Bool
    @StateObject var viewModel: WorkspaceAdminChangeViewModel
    @State var showAlert: AlertMessage? = nil
    
    init(isPresenting: Binding<Bool>, workspaceId: Int) {
        self._isPresenting = isPresenting
        self._viewModel = StateObject(wrappedValue: SharedAssembler.shared.resolve(WorkspaceAdminChangeViewModel.self, argument: workspaceId))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.members) { member in
                        WorkspaceChangeAdminMemberCell(member: member)
                            .padding([.leading, .trailing], 14)
                            .padding([.top, .bottom], 8)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .defaultBackground()
            .underlineNavigationBar(title: "워크스페이스 관리자 변경")
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
            .onAppear {
                viewModel.trigger(.appearView)
            }
            .onChange(of: viewModel.state.canChangeWorkspaceAdmin) { value in
                if !value {
                    showAlert = .init(title: "워크스페이스 관리자 변경 불가", description: "워크스페이스 멤버가 없어 관리자 변경을 할 수 없습니다. 새로운 멤버를 워크스페이스에 초대해보세요.", type: .ok(title: "확인"), action: {}, dismissAction: {
                        isPresenting = false
                    })
                }
            }
            .customAlert(alertMessage: $showAlert)
        }
        
    }
}

struct WorkspaceChangeAdminMemberCell: View {
    let member: UserThumbnailModel
    
    var body: some View {
        Button(action: {
            
        }, label: {
            HStack {
                FetchImageFromServerView(url: member.profileImagePath) {
                    Image(.noPhotoGreen)
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.white)
                }
                .frame(width: 44, height: 44)
                .clipShape(.rect(cornerRadius: 8))
                .padding(.trailing, 8)
                
                VStack(alignment: .leading) {
                    Text(member.nickname)
                        .font(CustomFont.bodyBold.font)
                        .foregroundStyle(.textPrimary)
                    Text(member.email)
                        .font(CustomFont.body.font)
                        .foregroundStyle(.textSecondary)
                }
                Spacer()
            }
        })
    }
}

#Preview {
    WorkspaceChangeAdminView(isPresenting: .constant(true), workspaceId: 1)
}
