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
    
    var body: some View {
        contentView
            .sheet(isPresented: $showInviteMember, content: {
                InviteMemberView(isPresenting: $showInviteMember)
            })
    }
    
    @ViewBuilder
    var contentView: some View {
        if viewModel.state.workspaceMembers.isEmpty {
            EmptyMemberDMView(showInviteMember: $showInviteMember)
        } else {
            DirectMessageView(memberList: $viewModel.state.workspaceMembers, dmList: $viewModel.state.dmRooms)
        }
    }
}

#Preview {
    DMBaseView()
}
