//
//  EmptyHomeView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/19.
//

import SwiftUI

struct EmptyHomeView: View {
    @State private var showWorkspaceInital = false
    
    var body: some View {
        VStack {
            VStack(spacing: 15) {
                VStack(spacing: 24) {
                    Text("워크스페이스를 찾을 수 없어요.")
                        .font(CustomFont.title1.font)
                    Text("관리자에게 초대를 요청하거나, 다른 이메일로 시도하거나 새로운 워크스페이스를 생성해주세요.")
                        .multilineTextAlignment(.center)
                        .font(CustomFont.body.font)
                        .padding([.leading, .trailing], 23)
                }
                .padding(.top, 35)
                Image(.workspaceEmpty)
                    .frame(width: 368)
                .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fill)
            }
            Spacer()
            KeyboardStickeyButton(isFocus: .constant(false), title: "워크스페이스 생성", isEnable: .constant(true)) {
                showWorkspaceInital = true
            }
        }
        .sheet(isPresented: $showWorkspaceInital, content: {
            WorkspaceInitalizeView(presenting: $showWorkspaceInital)
        })
        
    }
}

#Preview {
    EmptyHomeView()
}
