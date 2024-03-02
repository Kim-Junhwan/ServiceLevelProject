//
//  PaymentWebView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/03/01.
//

import Foundation
import SwiftUI

struct PaymentWebView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var viewModel: CoinShopViewModel
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let view = PaymentWebViewModeViewController()
        view.viewModel = viewModel
        view.presentationMode = presentationMode
        return view
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
}
