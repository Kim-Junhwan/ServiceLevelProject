//
//  ChannelListTableView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/20.
//

import Foundation
import SwiftUI
import UIKit

struct ChatListSection {
    let title: String
    var isOpened: Bool
}


struct ChannelListTableView: UIViewRepresentable {
    @Binding var directMessage: [DMRoomItemModel]
    @Binding var channelList: [ChannelListItemModel]
    @Binding var showChannelActionSheet: Bool
    @Binding var channelOpen: Bool
    @Binding var showInviteMember: Bool
    @Binding var dmOpen: Bool
    
    func makeUIView(context: Context) -> ExpandableTableView {
        let expandableTableView = ExpandableTableView()
        expandableTableView.tableView.delegate = context.coordinator
        return expandableTableView
    }
    
    func updateUIView(_ uiView: ExpandableTableView, context: Context) {
        uiView.updateTableView(channelOpen: channelOpen, channelList: channelList, dmOpen: dmOpen, dmList: directMessage)
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(directMessage: $directMessage, channelList: $channelList, showChannelActionSheet: $showChannelActionSheet, channelOpen: $channelOpen, dmOpen: $dmOpen, showInviteMember: $showInviteMember)
    }
    
    class Coordinator: NSObject, UITableViewDelegate, ChatListHeaderViewDelegate {
        
        @Binding var directMessage: [DMRoomItemModel]
        @Binding var channelList: [ChannelListItemModel]
        @Binding var showChannelActionSheet: Bool
        @Binding var channelOpen: Bool
        @Binding var dmOpen: Bool
        @Binding var showInviteMember: Bool
        
        let headers: [String] = ["채널", "다이렉트 메시지"]
        
        init(directMessage: Binding<[DMRoomItemModel]>, channelList: Binding<[ChannelListItemModel]>, showChannelActionSheet: Binding<Bool>, channelOpen: Binding<Bool>, dmOpen: Binding<Bool>, showInviteMember: Binding<Bool>) {
            self._directMessage = directMessage
            self._channelList = channelList
            self._showChannelActionSheet = showChannelActionSheet
            self._dmOpen = dmOpen
            self._channelOpen = channelOpen
            self._showInviteMember = showInviteMember
            super.init()
        }
        
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            if section != 2 {
                guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ChatListHeaderView.identifier) as? ChatListHeaderView else { return .init() }
                header.configHeader(title: headers[section], section: section, tableView: tableView, isOpened: false)
                header.delegate = self
                return header
            }
            return nil
        }
        
        func tapHeader(section: Int, _ tableView: UITableView) {
            if section == 0 {
                channelOpen.toggle()
            } else {
                dmOpen.toggle()
            }
        }
        
        func getToggleStatus(section: Int) -> Bool {
            if section == 0 {
                return channelOpen
            } else {
                return dmOpen
            }
        }
        
        func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: ChatListFooterView.identifier)
            if section == 2 {
                return nil
            }
            return footer
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if indexPath.section == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelTableViewCell.identifier, for: indexPath) as? ChannelTableViewCell else { return .init() }
                if indexPath.row == channelList.count {
                    cell.setImage(image:"plus", title: "채널 추가")
                    return cell
                }
                let channel = channelList[indexPath.row]
                cell.config(title: channel.name, newMessageCount: channel.newMessageCount)
                return cell
            } else if indexPath.section == 1 {
                if indexPath.row == directMessage.count {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelTableViewCell.identifier, for: indexPath) as? ChannelTableViewCell else { return .init() }
                    cell.setImage(image: "plus", title: "새 메시지 시작")
                    return cell
                }
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DirectMessageTableViewCell.identifier, for: indexPath) as? DirectMessageTableViewCell else { return .init() }
                let dm = directMessage[indexPath.row]
                cell.config(profile: dm.user.profileImagePath, name: dm.user.nickname, newMessageCount: dm.newMessageCount)
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelTableViewCell.identifier, for: indexPath) as? ChannelTableViewCell else { return .init() }
                cell.setImage(image: "plus", title: "팀원 추가")
                return cell
            }
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 41
        }
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            if section != 2 {
                return 56
            }
            return 0
        }
        
        func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            1
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if indexPath.section == 0 {
                if indexPath.row == channelList.count {
                    showChannelActionSheet = true
                }
            } else if indexPath.section == 1 {
                
            } else {
                showInviteMember = true
            }
        }
    }
}
