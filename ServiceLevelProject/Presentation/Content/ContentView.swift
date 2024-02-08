//
//  ContentView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    var viewModel: ContentViewModel = SharedAssembler.shared.resolve(ContentViewModel.self)
    
    var body: some View {
        content
    }
    
    @ViewBuilder
    private var content: some View {
        if appState.isLoggedIn {
            HomeView()
        } else {
            OnBoardingView()
                .onAppear {
                    viewModel.trigger(.autoLogin)
            }
        }
    }
}

class ContentViewModel: ViewModel {
    
    let loginUseCase: AutoLoginUseCase
    
    enum FlowInput {
        case checkLoggedIn
        case autoLogin
    }
    
    struct FlowState {
        var isLoggedIn: Bool = false
    }
    
    @Published var state: FlowState
    
    init(loginUseCase: AutoLoginUseCase) {
        self.loginUseCase = loginUseCase
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
            try await loginUseCase.excute()
        }
    }
}

final class MockAutoLoginUseCase: AutoLoginUseCase {
    func excute() async throws {
    }
    
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
