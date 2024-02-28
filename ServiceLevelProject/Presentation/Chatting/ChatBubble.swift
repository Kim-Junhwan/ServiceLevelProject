//
//  ChatBubble.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/28.
//

import SwiftUI

struct ChatBubble: View {
    let message: ChattingMessageModel
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            profileImageView
            HStack(alignment: .bottom) {
                VStack(alignment: .leading) {
                    
                    Text(message.user.nickname)
                        .font(CustomFont.caption.font)
                    
                    if let messageText = message.content {
                        if !messageText.isEmpty {
                            Text(messageText)
                                .font(CustomFont.body.font)
                                .padding(8)
                                .background {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(.brandInactive,lineWidth: 1.0)
                                }
                        }
                    }
                    
                    if !message.files.isEmpty {
                        ChatBubbleImageView(imagepathList: message.files)
                            .clipShape(.rect(cornerRadius: 12))
                    }
                }
                
                Text(DateFormatter.todatStandardFormatting(message.createdAt))
                    .foregroundStyle(.textSecondary)
                    .font(CustomFont.caption.font)
            }
            
            
            Spacer()
        }
    }
    
    var profileImageView: some View {
        FetchImageFromServerView(url: message.user.profileImagePath) {
            Image(.noPhotoGreen)
                .resizable()
                .scaledToFit()
                .foregroundStyle(.white)
        }
        .frame(width: 34, height: 34)
        .clipShape(.rect(cornerRadius: 8))
    }
}

struct ChatBubbleImageView: View {
    let imagepathList: [String]
    
    var body: some View {
        if imagepathList.count == 1 {
            serverImageView(url: imagepathList[0])
                .frame(height: 160)
        } else if imagepathList.count == 2 {
            HStack(spacing: 2) {
                serverImageView(url: imagepathList[0])
                serverImageView(url: imagepathList[1])
            }
            .frame(height: 80)
        } else if imagepathList.count == 3 {
            HStack(spacing: 2) {
                serverImageView(url: imagepathList[0])
                    .frame(width: 80)
                serverImageView(url: imagepathList[1])
                    .frame(width: 80)
                serverImageView(url: imagepathList[2])
                    .frame(width: 80)
            }
            .frame(height: 80)
        } else if imagepathList.count == 4 {
            VStack(spacing: 2) {
                HStack(spacing: 2) {
                    serverImageView(url: imagepathList[0])
                    serverImageView(url: imagepathList[1])
                }
                HStack(spacing: 2) {
                    serverImageView(url: imagepathList[2])
                    serverImageView(url: imagepathList[3])
                }
            }
            .frame(height: 160)
        } else if imagepathList.count == 5 {
            VStack(spacing: 2) {
                HStack(spacing: 2) {
                    serverImageView(url: imagepathList[0])
                    serverImageView(url: imagepathList[1])
                    serverImageView(url: imagepathList[2])
                }
                HStack(spacing: 2) {
                    serverImageView(url: imagepathList[3])
                    serverImageView(url: imagepathList[4])
                }
            }.frame(height: 160)
        }
    }
    
    func serverImageView(url: String) -> some View {
        FetchImageFromServerView(url: url) {
            Color.brandGreen
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipShape(.rect(cornerRadius: 4))
    }
}

#Preview {
    ChatBubble(message: .init(chatId: 1, content: "반가워요", createdAt: Date(), files: ["", "nil", "nil"], user: .init(userThumnail: .init(id: 123, email: "", nickname: "냥찡", profileImagePath: nil))))
}
