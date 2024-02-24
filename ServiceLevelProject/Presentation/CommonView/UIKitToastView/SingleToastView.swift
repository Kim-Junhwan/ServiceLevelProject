//
//  SingleToastView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/24.
//

import UIKit
import SwiftUI

class UIKitToastView: UIView {
    let toastLabel: PaddingLabel = {
        let label = PaddingLabel(padding: .init(top: 9, left: 16, bottom: 9, right: 16))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.backgroundColor = .brandGreen
        label.font = CustomFont.body.uifont
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        return label
    }()
    
    let bottomPadding: CGFloat
    let toastMessage: String
    
    init(toastMessage: String, bottomPadding: CGFloat, frame: CGRect) {
        self.bottomPadding = bottomPadding
        self.toastMessage = toastMessage
        super.init(frame: frame)
        configureView()
        setConstraints()
        toastLabel.text = toastMessage
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return nil
    }
    
    private func configureView() {
        addSubview(toastLabel)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            toastLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            toastLabel.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor, constant: -(24+bottomPadding))
        ])
    }
}

public class SingleToastView {
    
    static var toastView: UIKitToastView?
    static var toastWorkItem: DispatchWorkItem?
    @Binding var toast: Toast?
    
    init(toast: Binding<Toast?>) {
        self._toast = toast
    }
    
    deinit {
        print("singleToastViewDeinit")
    }
    
    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
    
    func show(message: String, bottomPadding: CGFloat = 0) {
        SingleToastView.toastWorkItem?.cancel()
        let task = DispatchWorkItem {
            self.hide()
        }
        SingleToastView.toastWorkItem = task
        DispatchQueue.main.asyncAfter(deadline: .now()+2.0, execute: task)
        
        if SingleToastView.toastView == nil{
            guard let windowScene = windowScene else {return}
            let frame = windowScene.screen.bounds
            let toastView = UIKitToastView(toastMessage: message, bottomPadding: bottomPadding, frame: frame)
            toastView.backgroundColor = .clear
            windowScene.keyWindow?.addSubview(toastView)
            SingleToastView.toastView = toastView
        } else {
            SingleToastView.toastView?.toastLabel.text = message
        }
    }
    
    func hide() {
        guard let toastView = SingleToastView.toastView else { return }
        SingleToastView.toastWorkItem?.cancel()
        SingleToastView.toastWorkItem = nil
        self.toast = nil
        SingleToastView.toastView = nil
        toastView.removeFromSuperview()
    }
}
