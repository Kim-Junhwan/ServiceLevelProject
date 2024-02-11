//
//  WorkspaceIntalizeView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/26.
//

import SwiftUI

struct WorkspaceIntalizeView: View {
    
    @Binding var presenting: Bool
    @StateObject private var viewModel: WorkspaceInializeViewModel = SharedAssembler.shared.resolve(WorkspaceInializeViewModel.self)
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    ImagePickerView(viewModel: viewModel.imageModel)
                    .padding(.bottom, 16)
                    
                    TitleTextField(title: "워크스페이스 이름", isValid: $viewModel.state.isValidTitle, placeHolder: "워크스페이스 이름을 입력하세요 (필수)", kind: .textField, textFieldTitle: $viewModel.title)
                        .padding(.bottom, 24)
                    TitleTextField(title: "워크스페이스 설명", isValid: .constant(true), placeHolder: "워크스페이스를 설명하세요 (옵션)", kind: .textField, textFieldTitle: $viewModel.description)
                    Spacer()
                    
                }
                .padding(24)
                VStack {
                    Spacer()
                        .toastView(toast: $viewModel.state.toast)
                    KeyboardStickeyButton(isFocus: .constant(false), title: "완료", isEnable: $viewModel.state.canTapCompleteButton) {
                        viewModel.trigger(.tapCompleteButton)
                    }
                }
            }
            .defaultBackground()
            .underlineNavigationBar(title: "워크스페이스 생성")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        presenting = false
                    }, label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.black)
                    })
                }
            }
            .onReceive(viewModel.$state, perform: { state  in
                presenting = !state.successCreateWorkspace
            })
        }
    }
}

#Preview {
    WorkspaceIntalizeView(presenting: .constant(true))
}
