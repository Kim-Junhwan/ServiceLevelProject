//
//  WorkspaceListView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/02.
//

import SwiftUI

struct WorkspaceListView: View {
    
    @Binding var isPresenting: Bool
    @EnvironmentObject var appState: AppState
    
    //MARK: - WorkspaceListView State
    @StateObject private var state: WorkspaceListViewState
    
    init(isPresenting: Binding<Bool>) {
        self._isPresenting = isPresenting
        self._state = StateObject(wrappedValue: .init())
    }
    
    var body: some View {
            HStack {
                GeometryReader { proxy in
                    ZStack(alignment: .bottom) {
                        Rectangle()
                            .fill(.white)
                            .frame(width: proxy.size.width * 0.8)
                            .clipShape(.rect(cornerRadius: 20))
                        VStack(alignment: .leading, spacing: 0) {
                            Spacer()
                                .frame(height: proxy.safeAreaInsets.bottom)
                            Rectangle()
                                .fill(.backgroundPrimary)
                                .clipShape(.rect(topTrailingRadius: 20))
                                .frame(height: 100)
                                .overlay(alignment: .bottomLeading) {
                                    Text("워크스페이스")
                                        .font(CustomFont.title1.font)
                                        .padding(17)
                                }
                            workspaceContent
                            .navigationTitle("워크스페이스")
                            .toolbar(.visible, for: .navigationBar)
                            .environmentObject(state)
                            
                            VStack(alignment: .leading) {
                                SideMenuOptionButton(title: "워크스페이스 추가", image: Image(systemName: "plus")) {
                                    state.showCreateWorkspace = true
                                }
                                SideMenuOptionButton(title: "도움말", image: Image(systemName: "questionmark.circle")) {
                                    print("도움말")
                                }
                            }
                            .padding([.leading], 16)
                        }
                        .offset(y: -proxy.safeAreaInsets.bottom)
                        .background(.clear)
                        .frame(width: proxy.size.width * 0.8)
                    }
                    .ignoresSafeArea()
                    .sheet(isPresented: $state.showCreateWorkspace, content: {
                        WorkspaceInitalizeView(presenting: $state.showCreateWorkspace)
                    })
                }
                Spacer()
            }
        
    }
    
    @ViewBuilder
    var workspaceContent: some View {
        if appState.workspaceList.isEmpty {
            SideMenuEmptyWorkspace()
                .frame(maxHeight: .infinity)
                .padding(24)
        } else {
            SideMenuWorkspaceListView(workspaceList: appState.workspaceList.map{ WorkspaceThumbnailModel(workspace: $0)})
                .padding([.leading, .trailing], 6)
        }
    }
}

final class WorkspaceListViewState: ObservableObject {
    @Published var showCreateWorkspace: Bool = false
    @Published var showActionSheet: Bool = false
    @Published var showEditWorkspace: Bool = false
    @Published var showAlert: Bool = false
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
    WorkspaceListView(isPresenting: .constant(false))
        .environmentObject(AppState())
}
