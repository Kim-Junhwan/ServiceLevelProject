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
    let viewModel: ContentViewModel
    
    var body: some View {
        content
    }
    
    @ViewBuilder
    private var content: some View {
        if appState.isLoggedIn {
            HomeTabView()
        } else {
            OnBoardingView()
                .onAppear {
                    viewModel.trigger(.autoLogin)
            }
        }
    }
}

extension ContentView {
    class ContentViewModel: ViewModel {
        
        let loginUseCase: AutoLoginUseCase
        let container: AuthorizationSceneDIContainer
        
        enum FlowInput {
            case checkLoggedIn
            case autoLogin
        }
        
        struct FlowState {
            var isLoggedIn: Bool = false
        }
        
        @Published var state: FlowState
        
        init(loginUseCase: AutoLoginUseCase, container: AuthorizationSceneDIContainer) {
            self.loginUseCase = loginUseCase
            self.container = container
            self.state = FlowState()
        }
        
        func trigger(_ input: FlowInput) {
            switch input {
            case .checkLoggedIn:
                break
            case .autoLogin:
                autoLogin()
            }
        }
        
        private func autoLogin() {
            Task {
                let loginPlatform = container.appState.loginInfo.loginType
                try await loginUseCase.excute(loginPlatform)
            }
        }
    }
}

final class MockAutoLoginUseCase: AutoLoginUseCase {
    func excute(_ platform: LoginPlatform) async throws {
    }
    
}

#Preview {
    ContentView(viewModel: .init(loginUseCase: MockAutoLoginUseCase(), container: .init()))
}
