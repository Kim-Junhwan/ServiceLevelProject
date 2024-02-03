//
//  WorkspaceListView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/02.
//

import SwiftUI

struct WorkspaceListView: View {
    
    @Binding var isPresenting: Bool
    
    func setNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .backgroundPrimary
        appearance.shadowColor = .clear
        appearance.largeTitleTextAttributes = [.font: CustomFont.title1.uifont]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
    
    init(isPresenting: Binding<Bool>) {
        self._isPresenting = isPresenting
        setNavigationBar()
    }
    
    var body: some View {
        HStack {
            ZStack {
                NavigationStack {
                    List {
                        
                    }
                    .navigationTitle("워크스페이스")
                }
                .frame(width: 270)
            }
            Spacer()
        }
        .background(.clear)
        
    }
}

#Preview {
    WorkspaceListView(isPresenting: .constant(true))
}
