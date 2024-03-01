//
//  DMBaseView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/19.
//

import SwiftUI

struct DMBaseView: View {
    @StateObject var viewModel: DMViewModel = SharedAssembler.shared.resolve(DMViewModel.self)
    @State var showInviteMember: Bool = false
    @State var selectUser: UserThumbnailModel?
    
    var body: some View {
        contentView
            .sheet(isPresented: $showInviteMember, content: {
                InviteMemberView(isPresenting: $showInviteMember)
            })
            .navigationDestination(isPresented: .constant(selectUser != nil)) {
                if let selectUser {
                    DMChattingView(selectUser: selectUser)
                }
            }
    }
    
    @ViewBuilder
    var contentView: some View {
        if viewModel.state.workspaceMembers.isEmpty {
            EmptyMemberDMView(showInviteMember: $showInviteMember)
        } else {
            DirectMessageView(memberList: $viewModel.state.workspaceMembers, dmList: $viewModel.state.dmRooms, selectUser: $selectUser)
                .onAppear {
                    viewModel.trigger(.appearView)
                }
        }
    }
}

#Preview {
    DMBaseView()
}
