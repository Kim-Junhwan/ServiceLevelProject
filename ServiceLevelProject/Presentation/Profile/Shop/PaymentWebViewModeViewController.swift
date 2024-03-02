//
//  PaymentWebViewModeViewController.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/03/01.
//

import UIKit
import WebKit
import iamport_ios
import SwiftUI

class PaymentWebViewModeViewController: UIViewController, WKNavigationDelegate {
    
    var presentationMode: Binding<PresentationMode>?
    var viewModel: CoinShopViewModel?
    
    private lazy var wkWebView: WKWebView = {
       let view = WKWebView()
        view.backgroundColor = UIColor.clear
        view.navigationDelegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func attachWebView() {
        view.addSubview(wkWebView)
        NSLayoutConstraint.activate([
            wkWebView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wkWebView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            wkWebView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            wkWebView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }
    
    private func removeWebView() {
        view.willRemoveSubview(wkWebView)
        wkWebView.stopLoading()
        wkWebView.removeFromSuperview()
        wkWebView.uiDelegate = nil
        wkWebView.navigationDelegate = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attachWebView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        requestPayment()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeWebView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        Iamport.shared.close()
        presentationMode?.wrappedValue.dismiss()
    }
    
    func requestPayment() {
        guard let viewModel = viewModel else { return }
        let userCode = viewModel.userCode
        if let payment = viewModel.createPatmentData() {
            Iamport.shared.paymentWebView(webViewMode: wkWebView, userCode: userCode, payment: payment) { [weak self] iamportResponse in
                viewModel.iamportCallBack(iamportResponse)
                self?.presentationMode?.wrappedValue.dismiss()
            }
        }
    }
}
