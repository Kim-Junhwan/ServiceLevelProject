//
//  HomeView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/19.
//

import SwiftUI

struct HomeView: View {
    
    @State var showWorkspaceList: Bool = false
    @State var toast: Toast? = nil
    @State var showEditProfile: Bool = false
    @State private var selectedTabIndex = 0
    @StateObject var viewModel: HomeViewModel = SharedAssembler.shared.resolve(HomeViewModel.self)
    
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
                    if !viewModel.state.workspaceIsEmpty {
                        HomeTabView(selectedTabIndex: $selectedTabIndex)
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
                                workspaceImageView
                                Text(viewModel.state.navigationTitle)
                                    .font(CustomFont.title1.font)
                                    .foregroundStyle(.black)
                            })
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            EditProfileView(imageData: viewModel.userProfileImage.imageData)
                        } label: {
                            userProfileView
                        }
                    }
                }
            }
            .onAppear {
                viewModel.trigger(.appearView)
            }
            SideMenu(isPresenting: $showWorkspaceList) {
                WorkspaceListView(isPresenting: $showWorkspaceList)
            }
            .onChange(of: selectedTabIndex) { value in
                if value == 0 {
                    viewModel.state.navigationTitle = viewModel.state.currentWorkspace?.name ?? "No Workspace"
                } else if value == 1 {
                    viewModel.state.navigationTitle = "Direct Message"
                }
            }
        }
        .toastView(toast: $toast)
        .gesture(dragGesture)
    }
    
    @ViewBuilder
    var userProfileView: some View {
        FetchImageFromServerView(imageModel: viewModel.userProfileImage) {
            Image(.noPhotoGreen)
                .resizable()
                .scaledToFit()
                .foregroundStyle(.white)
        }
        .frame(width: 32, height: 32)
        .background(.brandGreen)
        .clipShape(Circle())
        .overlay {
            Circle()
                .stroke(.black, lineWidth: 2)
        }
    }
    
    @ViewBuilder
    var workspaceImageView: some View {
        FetchImageFromServerView(imageModel: viewModel.workspaceImage) {
            Image(.workspaceBallon)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .offset(y: 5)
                .background(.brandGreen)
                .frame(width: 30, height: 30)
        }
        .frame(width: 32, height: 32)
        .clipShape(.rect(cornerRadius: 8))
    }
}

#Preview {
    HomeView()
        .environmentObject(AppState())
}
