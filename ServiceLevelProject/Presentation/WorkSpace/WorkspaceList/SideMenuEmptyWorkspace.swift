//
//  SideMenuEmprtWorkspace.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/04.
//

import SwiftUI

struct SideMenuEmptyWorkspace: View {
    @State private var showWorkspaceInital = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("워크스페이스를 찾을 수 없어요.")
                .font(CustomFont.title1.font)
            Text("관리자에게 초대를 요청하거나, 다른 이메일로 시도하거나 새로운 워크스페이스를 생성해주세요. ")
                .font(CustomFont.body.font)
            
            RoundedButton(action: {
                showWorkspaceInital = true
            }, label: {
                Text("워크스페이스 생성")
            }, backgroundColor: .brandGreen)
        }
        .multilineTextAlignment(.center)
        .sheet(isPresented: $showWorkspaceInital, content: {
            WorkspaceInitalizeView(presenting: $showWorkspaceInital)
        })
    }
}

#Preview {
    SideMenuEmptyWorkspace()
}
