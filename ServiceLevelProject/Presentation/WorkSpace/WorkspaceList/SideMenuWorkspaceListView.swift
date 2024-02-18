//
//  SideMenuWorkspaceListView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/04.
//

import SwiftUI

struct SideMenuWorkspaceListView: View {
    let workspaceList: [WorkspaceThumbnailModel]
    @EnvironmentObject var state: WorkspaceListViewState
    @EnvironmentObject var viewModel: WorkspaceSideMenuViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(workspaceList, id: \.workspaceId) { workspace in
                    WorkspaceSideMenuCell(workspace: workspace, isAdmin: viewModel.state.selectWorkspaceOwner, isSelected: viewModel.state.selectedWorkspace?.workspaceId == workspace.workspaceId) {
                        viewModel.trigger(.tapWorkspace(workspace))
                    }
                    .padding([.leading, .trailing], 6)
                    .padding([.top, .bottom], 3)
                }
            }
            .confirmationDialog("", isPresented: $state.showActionSheet) {
                workspaceActionSheet()
            }
        }
    }
    
    @ViewBuilder
    private func workspaceActionSheet() -> some View {
        if let selectedWorkspace = viewModel.state.selectedWorkspace {
            WorkspaceActionSheetView(isAdmin: viewModel.state.selectWorkspaceOwner, workspaceModel: selectedWorkspace)
        }
    }
}

struct WorkspaceSideMenuCell: View {
    // MARK: - Properties
    private let workspace: WorkspaceThumbnailModel
    private let isSelected: Bool
    private let action: ()-> Void
    private let isAdmin: Bool
    
    // MARK: - State
    @StateObject private var imageModel: FetchImageModel
    @EnvironmentObject var state: WorkspaceListViewState
    
    init(workspace: WorkspaceThumbnailModel, isAdmin: Bool, isSelected: Bool, action: @escaping () -> Void) {
        self.workspace = workspace
        self.isSelected = isSelected
        self.action = action
        self.isAdmin = isAdmin
        self._imageModel = StateObject(wrappedValue: FetchImageModel(url: workspace.imagePath))
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                FetchImageFromServerView(imageModel: imageModel, placeHolder: {
                    Image(.workspaceBallon)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 44, height: 44)
                        .offset(y: 5)
                        .background(.brandGreen)
                })
                .frame(width: 44, height: 44)
                .clipShape(.rect(cornerRadius: 8))
                .padding(.trailing, 8)
                
                VStack(alignment: .leading) {
                    Text(workspace.title)
                        .font(CustomFont.bodyBold.font)
                        .foregroundStyle(.textPrimary)
                    Text(workspace.createdAt)
                        .font(CustomFont.body.font)
                        .foregroundStyle(.textSecondary)
                }
                Spacer()
                if isSelected {
                    Button(action: {
                        state.showActionSheet = true
                    }, label: {
                        Image(systemName: "ellipsis")
                            .scaledToFit()
                            .foregroundStyle(.black)
                            .frame(width: 20, height: 20)
                    })
                }
            }
            .padding(8)
            .frame(maxWidth: .infinity)
            .background(isSelected ? .brandGray : .white, in: RoundedRectangle(cornerRadius: 10))
            .sheet(isPresented: $state.changeWorkspaceAdmin, content: {
                WorkspaceChangeAdminView(isPresenting: $state.changeWorkspaceAdmin, workspaceId: workspace.workspaceId)
            })
        }
    }
}

#Preview {
    SideMenuWorkspaceListView(workspaceList: [])
        .environmentObject(AppState())
}
