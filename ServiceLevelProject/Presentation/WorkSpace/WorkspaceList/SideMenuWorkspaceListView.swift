//
//  SideMenuWorkspaceListView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/04.
//

import SwiftUI

struct WorkspaceThumbnailModel: Identifiable {
    let id = UUID()
    let workspaceId: Int
    let title: String
    let createdAt: String
    let imagePath: String
    let ownerId: Int
    let description: String?
    
    init(workspace: WorkSpaceThumbnail) {
        self.workspaceId = workspace.id
        self.title = workspace.name
        self.description = workspace.description
        self.ownerId = workspace.ownerId
        self.createdAt = DateFormatter.yearMonthDateFormatter.string(from: workspace.createAt)
        self.imagePath = workspace.thumbnailPath
    }
}

struct SideMenuWorkspaceListView: View {
    let workspaceList: [WorkspaceThumbnailModel]
    @State private var selection: UUID?
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(workspaceList) { workspace in
                    WorkspaceSideMenuCell(workspace: workspace, userId: appState.userData.id, isSelected: workspace.id == selection) {
                        selection = workspace.id
                    }
                    .padding([.leading, .trailing], 6)
                    .padding([.top, .bottom], 3)
                }
                
            }
        }
    }
}

struct WorkspaceSideMenuCell: View {
    // MARK: - Properties
    private let workspace: WorkspaceThumbnailModel
    private let userId: Int
    private let isSelected: Bool
    private let action: ()-> Void
    
    // MARK: - State
    @StateObject private var imageModel: FetchImageModel
    @EnvironmentObject var state: WorkspaceListViewState
    
    init(workspace: WorkspaceThumbnailModel, userId: Int, isSelected: Bool, action: @escaping () -> Void) {
        self.workspace = workspace
        self.userId = userId
        self.isSelected = isSelected
        self.action = action
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
            .confirmationDialog("", isPresented: $state.showActionSheet) {
                WorkspaceActionSheetView(isAdmin: userId == workspace.ownerId, editWorkspace: $state.showEditWorkspace)
            }
            .sheet(isPresented: $state.showEditWorkspace, content: {
                WorkspaceEditView(workspace: workspace, imageData: imageModel.imageData ?? Data())
            })
        }
    }
}

#Preview {
    SideMenuWorkspaceListView(workspaceList: [])
        .environmentObject(AppState())
}
