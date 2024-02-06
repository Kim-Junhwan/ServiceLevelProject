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
}

struct SideMenuWorkspaceListView: View {
    @Binding var workspaceList: [WorkspaceThumbnailModel]
    @State private var selection: UUID?
    
    var body: some View {
        
        List(workspaceList) { workspace in
            WorkspaceSideMenuCell(workspace: workspace, isSelected: workspace.id == selection) {
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
    var isSelected: Bool
    let action: ()-> Void
    
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
                }
                Spacer()
                
                Button(action: {
                    print("Hello")
                }, label: {
                    Image(systemName: "ellipsis")
                        .scaledToFit()
                        .foregroundStyle(.black)
                        .frame(width: 20, height: 20)
                })
            }
            .padding(8)
            .frame(maxWidth: .infinity)
            .background(isSelected ? .brandGray : .white, in: RoundedRectangle(cornerRadius: 10))
        }
    }
}

#Preview {
    SideMenuWorkspaceListView(workspaceList: .constant([]))
        .environmentObject(AppState())
}
