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
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    if hasChatList {
                        HomeTabView()
                    } else {
                        EmptyHomeView()
                    }
                }
                .onAppear {
                    Task {
                        do {
                            let value = try await DefaultWorkspaceRepository().fetchComeInWorkspaceList()
                        }
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
                            })
                            Text("No WorkSpace")
                                .font(CustomFont.title1.font)
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            
                        }, label: {
                            Image(systemName: "xmark")
                        })
                    }
                }
                
            }
            SideMenu(isPresenting: $showWorkspaceList, content: AnyView(WorkspaceListView(isPresenting: $showWorkspaceList)))
        }
    }
}

#Preview {
    HomeView()
}
