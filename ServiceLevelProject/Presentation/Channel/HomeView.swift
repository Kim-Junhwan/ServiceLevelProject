//
//  HomeView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/19.
//

import SwiftUI

struct HomeView: View {
    
    @State var hasChatList: Bool = true
    @State var showWorkspaceList: Bool = false
    @EnvironmentObject var appState: AppState
    
    var dragGesture: some Gesture {
         DragGesture(minimumDistance: 100)
            .onChanged { gesture in
                if gesture.startLocation.x < CGFloat(20) {
                    showWorkspaceList = true
                }
            }
    }
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    if !appState.workspaceList.list.isEmpty {
                        HomeTabView()
                    } else {
                        EmptyHomeView()
                    }
                }
                .underlineNavigationBar(title: "")
                .toolbarBackground(.white, for: .navigationBar)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        HStack {
                            Button(action: {
                                showWorkspaceList = true
                            }, label: {
                                
                                Image(systemName: "star")
                                    .resizable()
                                    .frame(width: 32, height: 32)
                                    .background(.red)
                                    .clipShape(.rect(cornerRadius: 8))
                                Text("No WorkSpace")
                                    .font(CustomFont.title1.font)
                                    .foregroundStyle(.black)
                            })
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            
                        }, label: {
                            userProfileView
                                .frame(width: 32, height: 32)
                                .background(.brandGreen)
                                .clipShape(Circle())
                                .overlay {
                                    Circle()
                                        .stroke(.black, lineWidth: 2)
                                }
                        })
                    }
                }
            }
            SideMenu(isPresenting: $showWorkspaceList, content: AnyView(WorkspaceListView(isPresenting: $showWorkspaceList)))
        }
        .gesture(dragGesture)
    }
    
    @ViewBuilder
    var userProfileView: some View {
        if let profileUrl = appState.userData.profileImagePath {
            FetchImageFromServerView(url: profileUrl) {
                Image(.noPhotoGreen)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.white)
            }
        } else {
            Image(.noPhotoGreen)
                .resizable()
                .scaledToFit()
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    HomeView()
}
