//
//  DMBaseView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/19.
//

import SwiftUI

struct DMBaseView: View {
    @StateObject var viewModel: DMViewModel = SharedAssembler.shared.resolve(DMViewModel.self)
    
    var body: some View {
        contentView
    }
    
    @ViewBuilder
    var contentView: some View {
        if viewModel.state.workspaceMembers.isEmpty {
            EmptyMemberDMView()
        } else {
            Text("Hello")
        }
    }
}

#Preview {
    DMBaseView()
}
