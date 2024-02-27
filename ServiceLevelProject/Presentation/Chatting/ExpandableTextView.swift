//
//  ExpandableTextView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/27.
//

import SwiftUI
import UIKit

struct CustomTextView: UIViewRepresentable {
    
    @Binding var text: String
    @Binding var textViewHeight: CGFloat
    
    var placeholder: String?
    var placeholderColor: UIColor = .gray
    var defaultFontSize: CGFloat = 20.0
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView(frame: .zero)
        if let placeholder {
            textView.text = placeholder
            textView.textColor = placeholderColor
        }
        textView.font = CustomFont.body.uifont
        textView.backgroundColor = .clear
        textViewHeight = textView.contentSize.height
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textView.delegate = context.coordinator
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = self.text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text, textViewHeight: $textViewHeight)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        
        @Binding var text: String
        @Binding var textViewHeight: CGFloat
        
        let maxHeight: CGFloat = 70
        
        func textViewDidChange(_ textView: UITextView) {
            if textView.contentSize.height < maxHeight {
                textViewHeight = textView.contentSize.height
            }
        }
        
        func textViewDidChangeSelection(_ textView: UITextView) {
            self.text = textView.text ?? ""
        }
        
        init(text: Binding<String>, textViewHeight: Binding<CGFloat>) {
            self._text = text
            self._textViewHeight = textViewHeight
        }
        
    }
}
