//
//  WorkspaceListView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/02.
//

import SwiftUI

struct WorkspaceListView: View {
    
    @Binding var isPresenting: Bool
    @State var workspaceList: [Int] = [1,2,3]
    
    var body: some View {
            HStack {
                GeometryReader { proxy in
                    ZStack(alignment: .bottom) {
                        Rectangle()
                            .fill(.white)
                            .frame(width: proxy.size.width * 0.8)
                            .clipShape(.rect(cornerRadius: 20))
                        VStack(alignment: .leading, spacing: 0) {
                            Rectangle()
                                .fill(.backgroundPrimary)
                                .frame(height:100)
                                .clipShape(.rect(topTrailingRadius: 20))
                                .overlay(alignment: .bottomLeading) {
                                    Text("워크스페이스")
                                        .font(CustomFont.title1.font)
                                        .padding(17)
                                }
                            workspaceContent
                            .navigationTitle("워크스페이스")
                            .toolbar(.visible, for: .navigationBar)
                            VStack(alignment: .leading) {
                                SideMenuOptionButton(title: "워크스페이스 추가", image: Image(systemName: "plus")) {
                                    print("워크스페이스 추가")
                                }
                                SideMenuOptionButton(title: "도움말", image: Image(systemName: "questionmark.circle")) {
                                    print("도움말")
                                }
                            }
                            .offset(y: -proxy.safeAreaInsets.bottom)
                            .padding([.leading], 16)
                        }
                        .background(.clear)
                        .frame(width: proxy.size.width * 0.8)
                        .onAppear {
                            print(proxy.size)
                            print(proxy.safeAreaInsets)
                        }
                    }
                    .ignoresSafeArea()
                }
                Spacer()
            }
        
    }
    
    @ViewBuilder
    var workspaceContent: some View {
        if workspaceList.isEmpty {
            SideMenuEmptyWorkspace()
                .padding(24)
        } else {
            SideMenuWorkspaceListView()
                .padding([.leading, .trailing], 6)
        }
    }
}

struct SideMenuOptionButton: View {
    let title: String
    let image: Image
    let action: ()-> Void
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            HStack(spacing: 16) {
                image
                    .foregroundStyle(.textSecondary)
                Text(title)
                    .foregroundStyle(.textSecondary)
                    .font(CustomFont.caption.font)
            }
        })
        .frame(height: 41)
    }
}

#Preview {
    WorkspaceListView(isPresenting: .constant(true))
        .environmentObject(AppState())
}
