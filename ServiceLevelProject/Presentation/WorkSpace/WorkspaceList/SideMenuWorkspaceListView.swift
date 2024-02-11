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
}

struct SideMenuWorkspaceListView: View {
    @Binding var workspaceList: [WorkspaceThumbnailModel]
    @State private var selection: UUID?
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        
        List(workspaceList) { workspace in
            WorkspaceSideMenuCell(workspace: workspace, userId: appState.userData.id, isSelected: workspace.id == selection) {
                selection = workspace.id
            }
            .listRowInsets(.init(top: 6, leading: 2, bottom: 6, trailing: 2))
            .listRowSeparator(.hidden)
        }
        .listStyle(PlainListStyle())
        .scrollIndicators(.hidden)
    }
}

struct WorkspaceSideMenuCell: View {
    
    let workspace: WorkspaceThumbnailModel
    let userId: Int
    var isSelected: Bool
    let action: ()-> Void
    @State private var isConfirming = false
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                FetchImageFromServerView(url: workspace.imagePath, placeHolder: {
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
                WorkspaceActionSheetView(isAdmin: true)
            }
        }
    }
}

#Preview {
    SideMenuWorkspaceListView(workspaceList: .constant([]))
        .environmentObject(AppState())
}
