//
//  ContentView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var diContainer: AuthorizationSceneDIContainer
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        content
    }
    
    @ViewBuilder
    private var content: some View {
        if appState.isLoggedIn {
            HomeTabView()
        } else {
            OnBoardingView()
        }
    }
}

extension ContentView {
    class ContentViewModel: ObservableObject {
        
    }
}

#Preview {
    ContentView()
}
