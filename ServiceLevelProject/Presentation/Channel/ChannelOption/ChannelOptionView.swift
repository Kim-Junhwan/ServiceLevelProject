//
//  ChannelOptionView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/03/01.
//

import SwiftUI

struct ChannelOptionView: View {
    
    @State var memberList: [UserThumbnailModel]
    let channelName: String
    let channelDesciption: String = ""
    let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @State var isMemberOpen: Bool = true
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("#\(channelName)")
                        .font(CustomFont.title2.font)
                    Spacer()
                }
                HStack {
                    Text(channelDesciption)
                        .font(CustomFont.body.font)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                
            }
            .padding([.top, .leading, .trailing], 16)
            LazyVGrid(columns: columns) {
                Section(header: memberHeader) {
                    if isMemberOpen {
                        ForEach(memberList) { member in
                            memberCell(user: member)
                        }
                    }
                }
            }
            channelOptionButtonStack
                .padding([.leading, .trailing], 24)
            Spacer()
        }
        .underlineNavigationBar(title: "채널 설정")
        .defaultBackground()
    }
    
    var memberHeader: some View {
        Button(action: {
            withAnimation {
                isMemberOpen.toggle()
            }
        }, label: {
            HStack {
                Text("멤버 \(memberList.count)")
                    .font(CustomFont.title2.font)
                    .foregroundStyle(.black)
                Spacer()
                Image(systemName: "chevron.down")
            }
            .padding([.leading, .trailing], 16)
            .frame(height: 56)
        })
        
    }
    
    func memberCell(user: UserThumbnailModel) -> some View {
        VStack {
            FetchImageFromServerView(url: user.profileImagePath) {
                Image(.noPhotoGreen)
            }
            .frame(width: 44, height: 44)
            .clipShape(.rect(cornerRadius: 8))
            Text(user.nickname)
        }
    }
    
    var channelOptionButtonStack: some View {
        VStack(spacing: 8) {
            borderButton(title: "채널 편집") {
                
            }
            borderButton(title: "채널에서 나가기") {
                
            }
            borderButton(title: "채널 관리자 변경") {
                
            }
            borderButton(title: "채널 삭제") {
                
            }
            .foregroundStyle(.red)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.red, lineWidth: 1.0)
            }
        }
        .foregroundStyle(.black)
    }
    
    func borderButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action, label: {
            Text(title)
                .font(CustomFont.title2.font)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(.white)
                .clipShape(.rect(cornerRadius: 8))
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.black, lineWidth: 1.0)
                }
        })
    }
}

