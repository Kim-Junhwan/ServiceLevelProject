//
//  SideMenu.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/03.
//

import SwiftUI

struct SideMenu<ContentView: View>: View {
    
    @Binding var isPresenting: Bool
    var edgeTransition: AnyTransition = .move(edge: .leading)
    var content: ()-> ContentView
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if isPresenting {
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isPresenting = false
                    }
                content()
                    .transition(edgeTransition)
                    .background(.clear)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .animation(.easeInOut, value: isPresenting)
    }
}
