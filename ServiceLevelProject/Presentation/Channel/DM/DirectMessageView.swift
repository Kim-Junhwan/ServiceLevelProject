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
    
    var body: some View {
        List {
            VStack {
                ScrollView(.horizontal) {
                    LazyHGrid(rows: [GridItem(.fixed(300))], content: {
                        ForEach(memberList) { member in
                            memberProfileView(userThumbnail: member)
                        }
                    })
                }
                .frame(height: 100)
                ForEach(dmList) { dm in
                    Text(dm.user.nickname)
                        .listRowSeparator(.hidden)
                }
            }
            .listRowInsets(.init())
        }
        .padding(0)
        .listStyle(.plain)
        .listRowSeparator(.hidden)
    }
    
    @ViewBuilder
    func memberProfileView(userThumbnail: UserThumbnailModel) -> some View {
        Button(action: {
            
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
    
    @ViewBuilder
    func DMRoomView(dmRoom: DMRoomItemModel) -> some View {
        Button(action: {
            
        }, label: {
//            HStack {
//                FetchImageFromServerView(url: dmRoom.user.profileImagePath) {
//                    Image(.noPhotoGreen)
//                }
//                VStack {
//                    HStack {
//                        Text(dmRoom.user.nickname)
//                        Spacer()
//                        Text(dmRoom.)
//                    }
//                }
//            }
        })
    }
}

#Preview {
    DirectMessageView(memberList: .constant([.init(userThumnail: .init(id: 0, email: "123", nickname: "chatliu", profileImagePath: nil)), .init(userThumnail: .init(id: 3, email: "123", nickname: "나마", profileImagePath: nil))]), dmList: .constant([
        .init(dm: .init(workspaceId: 123, roomId: 12, createdAt: Date(), user: .init(id: 0, email: "123", nickname: "chatliu", profileImagePath: nil)))
    ]))
}
