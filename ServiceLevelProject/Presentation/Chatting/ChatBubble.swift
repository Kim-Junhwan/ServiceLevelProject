//
//  ChatBubble.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/28.
//

import SwiftUI

struct ChatBubble: View {
    let message: Message
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            profileImageView
            HStack(alignment: .bottom) {
                VStack(alignment: .leading) {
                    Text(message.username)
                        .font(CustomFont.caption.font)
                    if let messageText = message.message {
                        Text(messageText)
                            .font(CustomFont.body.font)
                            .padding(8)
                            .background {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(.brandInactive,lineWidth: 1.0)
                            }
                    }
                    if !message.photo.isEmpty {
                        ChatBubbleImageView(imagepathList: message.photo)
                            .clipShape(.rect(cornerRadius: 12))
                    }
                }
                .layoutPriority(1)
                
                Text(DateFormatter.todatStandardFormatting(message.time))
                    .foregroundStyle(.textSecondary)
                    .font(CustomFont.caption.font)
                    .frame(minWidth: 60)
            }
            
            
            Spacer()
        }
    }
    
    var profileImageView: some View {
        FetchImageFromServerView(url: message.profilePath) {
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
                serverImageView(url: imagepathList[1])
                serverImageView(url: imagepathList[2])
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
        .clipShape(.rect(cornerRadius: 4))
    }
}

#Preview {
    ChatBubble(message: .init(message: "나는 낭만고양이", photo: [""], profilePath: nil, myMsg: true, time: Date(), username: "고양이"))
}
