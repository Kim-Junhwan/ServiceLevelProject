//
//  SideMenuWorkspaceListView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/04.
//

import SwiftUI

struct WorkspaceThumbnailModel: Identifiable {
    let id = UUID()
    let title: String
    let createdAt: String
    let imagePath: String
    let ownerId: Int
    let description: String?
}

struct SideMenuWorkspaceListView: View {
    @Binding var workspaceList: [WorkspaceThumbnailModel]
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
//        List(workspaceList) { workspace in
//            WorkspaceSideMenuCell(workspace: workspace, userId: appState.userData.id, isSelected: workspace.id == selection) {
//                selection = workspace.id
//            }
//            .listRowInsets(.init(top: 6, leading: 2, bottom: 6, trailing: 2))
//            .listRowSeparator(.hidden)
//        }
//        .listStyle(PlainListStyle())
//        .scrollIndicators(.hidden)
    }
}

struct WorkspaceSideMenuCell: View {
    
    private let workspace: WorkspaceThumbnailModel
    private let userId: Int
    private let isSelected: Bool
    private let action: ()-> Void
    @StateObject private var imageModel: FetchImageModel
    @State private var isConfirming = false
    @State private var showAlert = false
    @State private var showEditWorkspace = false
    
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
                        isConfirming = true
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
            .confirmationDialog("", isPresented: $isConfirming) {
                WorkspaceActionSheetView(isAdmin: userId == workspace.ownerId, editWorkspace: $showEditWorkspace)
            }
            .sheet(isPresented: $showEditWorkspace, content: {
                WorkspaceEditView(isPresenting: $showEditWorkspace, title: workspace.title, description: workspace.description, imageData: imageModel.imageData ?? Data())
            })
        }
    }
}

#Preview {
    SideMenuWorkspaceListView(workspaceList: .constant([]))
        .environmentObject(AppState())
}
