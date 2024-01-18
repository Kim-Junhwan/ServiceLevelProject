//
//  HomeView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/19.
//

import SwiftUI

struct HomeNavigationBarView: View {
    
    @State var hasChatList: Bool = true
    
    var body: some View {
        NavigationStack {
            VStack {
                if hasChatList {
                    HomeTabView()
                } else {
                    EmptyHomeView()
                }
            }
            .underlineNavigationBar(title: "")
            .toolbarBackground(.white, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack {
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            Image(systemName: "star")
                        })
                        Text("No WorkSpace")
                            .font(CustomFont.title1.font)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "xmark")
                    })
                }
            }
        }
    }
}

#Preview {
    HomeNavigationBarView()
}
