//
//  WorkspaceActionSheetView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/12.
//

import SwiftUI

struct WorkspaceActionSheetView: View {
    let isAdmin: Bool
    @EnvironmentObject var state: WorkspaceListViewState
    
    var body: some View {
        if isAdmin {
            Button("워크스페이스 편집") {
                state.showEditWorkspace = true
            }
            
            Button("워크스페이스 나가기") {
                state.showAlert = .init(title: "워크스페이스 나가기", description: "회원님은 워크스페이스 관리자입니다. 워크스페이스 관리자를 다른 멤버로 변경 한 후 나갈 수 있습니다.", type: .ok(title: "확인"), action: {
                    state.showAlert = nil
                })
            }
            
            Button("워크스페이스 관리자 변경") {
                state.changeWorkspaceAdmin = true
            }
            
            Button("워크스페이스 삭제", role: .destructive) {
                state.showAlert = .init(title: "워크스페이스 삭제", description: "정말 이 워크스페이스를 삭제하시겠습니까? 삭제 시 채널/멤버/채팅 등 워크스페이스 내의 모든 정보가 삭제되며 복구할 수 없습니다.", type: .cancelOk(cancelTitle: "취소", okTitle: "삭제"), action: {
                    
                })
            }
        } else {
            Button("워크스페이스 나가기") {
                state.showAlert = .init(title: "워크스페이스 나가기", description: "정말 이 워크스페이스를 떠나시겠습니까?", type: .cancelOk(cancelTitle: "취소", okTitle: "나가기"), action: {
                    
                })
            }
        }
        
        Button("취소", role: .cancel) {}
    }
}
