//
//  ContentView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/21.
//

import SwiftUI
import Combine

struct ContentView: View {
    @StateObject var viewModel: ContentViewModel = SharedAssembler.shared.resolve(ContentViewModel.self)
    
    var body: some View {
        content
    }
    
    @ViewBuilder
    private var content: some View {
        if viewModel.state.isLoggedIn {
            HomeView()
        } else {
            OnBoardingView()
                .onAppear {
                    viewModel.trigger(.autoLogin)
            }
        }
    }
}


class ContentViewModel: ViewModel, ObservableObject {
    
    enum FlowInput {
        case checkLoggedIn
        case autoLogin
    }
    
    struct FlowState {
        var isLoggedIn: Bool = false
    }
    
    @Published var state: FlowState
    let loginUseCase: AutoLoginUseCase
    let appState: AppState
    private var cancellableBag = Set<AnyCancellable>()
    
    init(loginUseCase: AutoLoginUseCase, appState: AppState) {
        self.loginUseCase = loginUseCase
        self.state = FlowState()
        self.appState = appState
        setUpBinding()
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
    
    private func setUpBinding() {
        appState.$isLoggedIn
            .receive(on: RunLoop.main)
            .sink { value in
                self.state.isLoggedIn = value
            }
            .store(in: &cancellableBag)
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
