//
//  ContentView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

extension ContentView {
    class ContentViewModel: ObservableObject {
        let container: AuthorizationSceneDIContainer
    }
}

#Preview {
    ContentView()
}
