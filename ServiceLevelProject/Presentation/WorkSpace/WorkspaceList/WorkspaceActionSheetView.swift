//
//  WorkspaceActionSheetView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/12.
//

import SwiftUI

struct WorkspaceActionSheetView: View {
    let isAdmin: Bool
    @State var workspaceOutAlert = false
    @State var adminWorkspaceOut = false
    @Binding var editWorkspace: Bool
    @State var workspaceDelete = false
    
    var body: some View {
        if isAdmin {
            Button("워크스페이스 편집") {
                editWorkspace = true
            }
            
            Button("워크스페이스 나가기") {
                adminWorkspaceOut = true
            }
            .customAlert(title: "워크스페이스 나가기", description: "회원님은 워크스페이스 관리자입니다. 워크스페이스 관리자를 다른 멤버로 변경 한 후 나갈 수 있습니다.", actionTitle: "확인", isPresenting: $adminWorkspaceOut) {
                adminWorkspaceOut = false
            }
            
            Button("워크스페이스 관리자 변경") {
                
            }
            
            Button("워크스페이스 삭제", role: .destructive) {
                workspaceDelete = true
            }
            .customAlert(title: "워크스페이스 삭제", description: "정말 이 워크스페이스를 삭제하시겠습니까? 삭제 시 채널/멤버/채팅 등 워크스페이스 내의 모든 정보가 삭제되며 복구할 수 없습니다.", cancelTitle: "취소", actionTitle: "확인", isPresenting: $workspaceDelete) {
                print("워크스페이스 삭제")
                workspaceDelete = false
            }
        } else {
            Button("워크스페이스 나가기") {
                workspaceOutAlert = true
            }
        }
        
        Button("취소", role: .cancel) {}
    }
}
