//
//  TitleTextField.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/01/03.
//

import SwiftUI

struct TitleTextField<SplitView: View>: View {
    
    enum TextFieldKind {
        case textField
        case secureField
    }
    
    var title: String
    var placeHolder: String
    var kind: TextFieldKind
    @Binding var textFieldTitle: String
    var splitView: (() -> SplitView)?
    
    init(title: String, placeHolder: String, kind: TextFieldKind, textFieldTitle: Binding<String>, splitView: (() -> SplitView)?) {
        self.title = title
        self.placeHolder = placeHolder
        self.kind = kind
        self._textFieldTitle = textFieldTitle
        self.splitView = splitView
    }
    
    init(title: String, placeHolder: String, kind: TextFieldKind, textFieldTitle: Binding<String>) where SplitView == EmptyView {
        self.title = title
        self.placeHolder = placeHolder
        self.kind = kind
        self._textFieldTitle = textFieldTitle
    }
    
    @ViewBuilder
    func getField() -> some View {
        switch kind {
        case .textField:
            TextField(placeHolder, text: $textFieldTitle)
        case .secureField:
            SecureField(placeHolder, text: $textFieldTitle)
        }
    }
    
    var body: some View {
        VStack (alignment: .leading, spacing: 8) {
            Text(title)
                .font(CustomFont.title2.font)
            
            HStack (spacing: 12) {
                getField()
                    .frame(height: 44)
                    .padding(.leading, 12)
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.white)
                    }
                .font(CustomFont.body.font)
                splitView?()
            }
        }
    }
}

#Preview {
    TitleTextField(title: "123", placeHolder: "123", kind: .textField, textFieldTitle: .constant("123")) {
        Text("123")
    }
}
