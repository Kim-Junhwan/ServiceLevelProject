//
//  WorkspaceActionSheetView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/12.
//

import SwiftUI

struct WorkspaceActionSheetView: View {
    let isAdmin: Bool
    
    var body: some View {
        if isAdmin {
            Button("워크스페이스 편집") {
                
            }
            
            Button("워크스페이스 나가기") {
                
            }
            
            Button("워크스페이스 관리자 변경") {
                
            }
            
            Button("워크스페이스 삭제", role: .destructive) {
                
            }
        } else {
            Button("워크스페이스 나가기") {
                
            }
        }
        
        Button("취소", role: .cancel) {
            
        }
    }
}

#Preview {
    WorkspaceActionSheetView(isAdmin: true)
}
