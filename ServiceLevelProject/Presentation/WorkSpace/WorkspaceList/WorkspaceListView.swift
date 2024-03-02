//
//  WorkspaceListView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/02.
//

import SwiftUI

struct WorkspaceListView: View {
    
    @Binding var isPresenting: Bool
    
    //MARK: - WorkspaceListView State
    @StateObject private var state: WorkspaceListViewState
    @StateObject private var viewModel: WorkspaceSideMenuViewModel = SharedAssembler.shared.resolve(WorkspaceSideMenuViewModel.self)
    
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
                            .clipShape(.rect(bottomTrailingRadius: 20, topTrailingRadius: 20))
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
                            .environmentObject(viewModel)
                            
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
                    .sheet(isPresented: .constant(state.showEditWorkspace != nil), onDismiss: {
                        state.showEditWorkspace = nil
                    }, content: {
                        workspaceEditView()
                            .environmentObject(state)
                    })
                    .customAlert(alertMessage: $state.showAlert)
                    .customAlert(alertMessage: $viewModel.state.showAlert)
                }
                Spacer()
            }
    }
    
    @ViewBuilder
    func workspaceEditView() -> some View {
        if let editingWorkspace = state.showEditWorkspace {
            WorkspaceEditView(workspace: editingWorkspace)
        }
    }
    
    @ViewBuilder
    var workspaceContent: some View {
        if viewModel.state.workspaceIsEmpty {
            SideMenuEmptyWorkspace()
                .frame(maxHeight: .infinity)
                .padding(24)
        } else {
            SideMenuWorkspaceListView(workspaceList: viewModel.state.workspaceList)
                .padding([.leading, .trailing], 6)
        }
    }
}

final class WorkspaceListViewState: ObservableObject {
    @Published var showCreateWorkspace: Bool = false
    @Published var showActionSheet: Bool = false
    @Published var showEditWorkspace: WorkspaceThumbnailModel? = nil
    @Published var changeWorkspaceAdmin: Bool = false
    @Published var showAlert: AlertMessage? = nil
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
