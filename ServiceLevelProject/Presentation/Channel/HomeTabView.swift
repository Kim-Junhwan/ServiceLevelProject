//
//  HomeView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/19.
//

import SwiftUI

struct HomeTabView: View {
    @Binding var selectedTabIndex: Int
    
    var body: some View {
        TabView(selection: $selectedTabIndex) {
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
                    .tag(0)
                
                DMBaseView()
                    .tabItem {
                        Label(
                            title: { Text("DM") },
                            icon: {
                                Image(.rightArrow)
                                    .renderingMode(.template).resizable()
                            }
                        )
                    }
                    .tag(1)
                
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
                    .tag(2)
                
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
                    .tag(3)
            }
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(.red, for: .tabBar)
        }
        .accentColor(.black)
    }
}

#Preview {
    HomeTabView(selectedTabIndex: .constant(0))
}
