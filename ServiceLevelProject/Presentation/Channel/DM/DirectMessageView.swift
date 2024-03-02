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
    @Binding var showDMChatting: Bool
    @Binding var selectUser: UserThumbnailModel?
    
    var body: some View {
        List {
            ScrollView(.horizontal) {
                LazyHGrid(rows: [GridItem(.fixed(100))], content: {
                    ForEach(memberList) { member in
                        DMUserProfileView(userThumbnail: member) {
                            selectUser = member
                            showDMChatting = true
                        }
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
                DMRoomView(dmRoom: dm) {
                    selectUser = dm.user
                    showDMChatting = true
                }
                .frame(maxWidth: .infinity)
                .listRowSeparator(.hidden)
                .listRowInsets(.init())
            }
            .padding(16)
        }
        .padding(0)
        .listStyle(.plain)
        .listRowSeparator(.hidden)
    }
}

struct DMRoomView: View {
    
    let dmRoom: DMRoomItemModel
    @StateObject var imageModel: FetchImageModel
    let action: () -> Void
    
    init(dmRoom: DMRoomItemModel, action: @escaping () -> Void) {
        self.dmRoom = dmRoom
        self.action = action
        self._imageModel = StateObject(wrappedValue: .init(url: dmRoom.user.profileImagePath))
    }
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            HStack {
                FetchImageFromServerView(imageModel: imageModel) {
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
                        Text(dmRoom.thumbnailContent)
                            .font(.system(size: 11))
                            .foregroundStyle(.textSecondary)
                        Spacer()
                        if dmRoom.newMessageCount != 0 {
                            Text("\(dmRoom.newMessageCount)")
                                .font(CustomFont.caption.font)
                                .padding([.leading, .trailing], 4)
                                .foregroundStyle(.white)
                                .background(.brandGreen)
                                .background(in: .capsule)
                        }
                    }
                }
            }
        })
    }
}

struct DMUserProfileView: View {
    
    let userThumbnail: UserThumbnailModel
    @StateObject var imageModel: FetchImageModel
    let action: () -> Void
    
    init(userThumbnail: UserThumbnailModel, action: @escaping () -> Void) {
        self.userThumbnail = userThumbnail
        self.action = action
        self._imageModel = StateObject(wrappedValue: .init(url: userThumbnail.profileImagePath))
    }
    
    var body: some View {
        Button(action: {
            action()
        }, label: {
            VStack(alignment: .center, spacing: 4) {
                FetchImageFromServerView(imageModel: imageModel) {
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
}

#Preview {
    DirectMessageView(memberList: .constant([.init(userThumnail: .init(id: 0, email: "123", nickname: "chatliu", profileImagePath: nil)), .init(userThumnail: .init(id: 3, email: "123", nickname: "나마", profileImagePath: nil))]), dmList: .constant([]), showDMChatting: .constant(false), selectUser: .constant(nil))
}
