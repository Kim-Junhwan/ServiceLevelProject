//
//  CoinShopView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/19.
//

import SwiftUI

struct CoinShopView: View {
    
    @StateObject var viewModel: CoinShopViewModel = SharedAssembler.shared.resolve(CoinShopViewModel.self)
    @State var showPatmentWebView: Bool = false
    
    var body: some View {
        VStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 8)
                .fill(.white)
                .frame(height: 44)
                .overlay {
                    HStack {
                        Text("🌱 현재 보유한 코인")
                            .font(CustomFont.bodyBold.font)
                        Text("\(viewModel.state.hasCoin)개")
                            .font(CustomFont.bodyBold.font)
                            .foregroundStyle(.brandGreen)
                        Spacer()
                        Text("코인이란?")
                            .font(CustomFont.caption.font)
                            .foregroundStyle(.textSecondary)
                    }
                    .padding([.leading, .trailing], 15)
                }
            LazyVStack(spacing: 0) {
                ForEach(viewModel.state.coinList) { coin in
                    CoinCell(coin: coin) {
                        viewModel.trigger(.tapBuyButton(coin))
                        showPatmentWebView = true
                    }
                }
            }
            .clipShape(.rect(cornerRadius: 8))
            Spacer()
        }
        .padding(24)
        .background(.backgroundPrimary)
        .underlineNavigationBar(title: "코인샵")
        .toolbarBackground(.white, for: .navigationBar)
        .onAppear {
            viewModel.trigger(.appearView)
        }
        .navigationDestination(isPresented: $showPatmentWebView) {
            PaymentWebView(viewModel: viewModel)
        }
        .singleToastView(toast: $viewModel.state.toast)
    }
    
    
}

struct CoinCell: View {
    let coin: CoinItemModel
    let action: () -> Void
    
    var body: some View {
        HStack {
            Text("🌱 \(coin.name)")
                .font(CustomFont.bodyBold.font)
            Spacer()
            Button(action: {
                action()
            }, label: {
                Text("￦\(coin.price)")
                    .font(CustomFont.title2.font)
                    .foregroundStyle(.white)
                    .frame(width: 74, height: 28)
                    .background(.brandGreen)
                    .background(in: .rect(cornerRadius: 8))
            })
        }
        .padding([.leading, .trailing], 15)
        .frame(height: 44)
        .background(.white)
    }
}

#Preview {
    CoinShopView()
}
