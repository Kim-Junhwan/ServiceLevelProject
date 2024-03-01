//
//  DirectMessageView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/26.
//

import SwiftUI

struct DirectMessageView: View {
    
    @Binding var memberList: [UserThumbnailModel]
    @Binding var dmList: [DMRoomItemModel]
    @Binding var selectUser: UserThumbnailModel?
    
    var body: some View {
        List {
            ScrollView(.horizontal) {
                LazyHGrid(rows: [GridItem(.fixed(100))], content: {
                    ForEach(memberList) { member in
                        memberProfileView(userThumbnail: member)
                    }
                })
            }
            .listRowInsets(.init())
            .frame(height: 100)
            .overlay {
                VStack {
                    Spacer()
                    Rectangle()
                        .fill(.seperator)
                        .frame(height: 1)
                }
            }
            ForEach(dmList) { dm in
                dMRoomView(dmRoom: dm)
                    .listRowSeparator(.hidden)
                    .listRowInsets(.init())
            }
            .padding(16)
        }
        .padding(0)
        .listStyle(.plain)
        .listRowSeparator(.hidden)
    }
    
    func memberProfileView(userThumbnail: UserThumbnailModel) -> some View {
        Button(action: {
            selectUser = userThumbnail
        }, label: {
            VStack(alignment: .center, spacing: 4) {
                FetchImageFromServerView(url: userThumbnail.profileImagePath) {
                    Image(.noPhotoGreen)
                }
                .frame(width: 44, height: 44)
                .clipShape(.rect(cornerRadius: 8))
                Text(userThumbnail.nickname)
                    .tint(.black)
                    .font(CustomFont.body.font)
            }
        })
        .frame(width: 76, height: 100)
    }
    
    func dMRoomView(dmRoom: DMRoomItemModel) -> some View {
        Button(action: {
            print("Hello")
        }, label: {
            HStack {
                FetchImageFromServerView(url: dmRoom.user.profileImagePath) {
                    Image(.noPhotoGreen)
                        .resizable()
                }
                .frame(width: 34, height: 34)
                .clipShape(.rect(cornerRadius: 8))
                VStack {
                    HStack {
                        Text(dmRoom.user.nickname)
                            .font(CustomFont.caption.font)
                        Spacer()
                        Text(dmRoom.createdAt)
                            .font(CustomFont.caption.font)
                            .foregroundStyle(.textSecondary)
                    }
                    HStack {
                        Text(dmRoom.user.nickname)
                            .font(.system(size: 11))
                            .foregroundStyle(.textSecondary)
                        Spacer()
                    }
                }
            }
        })
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    DirectMessageView(memberList: .constant([.init(userThumnail: .init(id: 0, email: "123", nickname: "chatliu", profileImagePath: nil)), .init(userThumnail: .init(id: 3, email: "123", nickname: "나마", profileImagePath: nil))]), dmList: .constant([
        .init(dm: .init(workspaceId: 123, roomId: 12, createdAt: Date(), user: .init(id: 0, email: "123", nickname: "chatliu", profileImagePath: nil))),
        .init(dm: .init(workspaceId: 123, roomId: 12, createdAt: Date(), user: .init(id: 0, email: "123", nickname: "chatliu", profileImagePath: nil))),
        .init(dm: .init(workspaceId: 123, roomId: 12, createdAt: Date(), user: .init(id: 0, email: "123", nickname: "chatliu", profileImagePath: nil)))
    ]), selectUser: .constant(nil))
}
