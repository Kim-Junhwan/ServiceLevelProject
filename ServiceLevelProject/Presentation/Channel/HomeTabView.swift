//
//  HomeView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/19.
//

import SwiftUI

struct HomeTabView: View {
    var body: some View {
        TabView {
            Group {
                ChatListView()
                    .tabItem {
                        Label(
                            title: { Text("홈") },
                            icon: {
                                Image(.list)
                                    .renderingMode(.template).resizable()
                            }
                        )
                }
                
                DMView()
                    .tabItem {
                        Label(
                            title: { Text("DM") },
                            icon: {
                                Image(.rightArrow)
                                    .renderingMode(.template).resizable()
                            }
                        )
                    }
                
                SearchView()
                    .tabItem {
                        Label(
                            title: { Text("검색") },
                            icon: {
                                Image(.smile)
                                    .renderingMode(.template).resizable()
                            }
                        )
                    }
                
                OptionView()
                    .tabItem {
                        Label(
                            title: { Text("설정") },
                            icon: {
                                Image(.window)
                                    .renderingMode(.template).resizable()
                            }
                        )
                    }
            }
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(.red, for: .tabBar)
        }
        .accentColor(.black)
    }
}

#Preview {
    HomeTabView()
}
