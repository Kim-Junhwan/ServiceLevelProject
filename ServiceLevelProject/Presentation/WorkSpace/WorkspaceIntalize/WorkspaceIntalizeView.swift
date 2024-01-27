//
//  WorkspaceIntalizeView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/26.
//

import SwiftUI

struct WorkspaceIntalizeView: View {
    
    @Binding var presenting: Bool
    @ObservedObject private var viewModel: WorkspaceInializeViewModel = .init()
    @StateObject var imageViewModel = ImageModel(maxSize: 70)
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    ImagePickerView(viewModel: imageViewModel)
                    .padding(.bottom, 16)
                    
                    TitleTextField(title: "워크스페이스 이름", isValid: $viewModel.state.isValidTitle, placeHolder: "워크스페이스 이름을 입력하세요 (필수)", kind: .textField, textFieldTitle: $viewModel.title)
                        .padding(.bottom, 24)
                    TitleTextField(title: "워크스페이스 설명", isValid: .constant(true), placeHolder: "워크스페이스를 설명하세요 (옵션)", kind: .textField, textFieldTitle: $viewModel.description)
                    Spacer()
                    
                }
                .padding(24)
                VStack {
                    Spacer()
                    KeyboardStickeyButton(isFocus: .constant(false), title: "완료", isEnable: $viewModel.state.canTapCompleteButton) {
                        
                    }
                }
            }
            .defaultBackground()
            .underlineNavigationBar(title: "워크스페이스 생성")
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.black)
                })
            }
        }
    }
}

#Preview {
    WorkspaceIntalizeView(presenting: .constant(true))
}
