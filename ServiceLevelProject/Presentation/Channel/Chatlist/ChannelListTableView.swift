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

struct ChannelModel {
    let title: String
    let newMessageCount: Int
}


struct ChannelListTableView: UIViewRepresentable {
    let directMessage: [DirectMessage]
    let channelList: [Channel]
    
    func makeUIView(context: Context) -> UITableView {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ChatListHeaderView.self, forHeaderFooterViewReuseIdentifier: ChatListHeaderView.identifier)
        tableView.register(ChatListFooterView.self, forHeaderFooterViewReuseIdentifier: ChatListFooterView.identifier)
        tableView.register(ChannelTableViewCell.self, forCellReuseIdentifier: ChannelTableViewCell.identifier)
        tableView.register(DirectMessageTableViewCell.self, forCellReuseIdentifier: DirectMessageTableViewCell.identifier)
        tableView.sectionHeaderTopPadding = 1
        tableView.separatorStyle = .none
        tableView.dataSource = context.coordinator
        tableView.delegate = context.coordinator
        return tableView
    }
    
    func updateUIView(_ uiView: UITableView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(directMessage: directMessage, channelList: channelList)
    }
    
    class Coordinator: NSObject, UITableViewDelegate, UITableViewDataSource, ChatListHeaderViewDelegate {
        
        let directMessage: [DirectMessage]
        let channelList: [Channel]
        
        init(directMessage: [DirectMessage], channelList: [Channel]) {
            self.directMessage = directMessage
            self.channelList = channelList
        }
        
        var headers: [ChatListSection] = [.init(title: "채널", isOpened: false), .init(title: "다이렉트 메시지", isOpened: false)]
        
        func numberOfSections(in tableView: UITableView) -> Int {
            3
        }
        
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            if section != 2 {
                guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ChatListHeaderView.identifier) as? ChatListHeaderView else { return .init() }
                header.configHeader(title: headers[section].title, section: section, tableView: tableView, isOpened: headers[section].isOpened)
                header.delegate = self
                return header
            }
            return nil
        }
        
        func tapHeader(section: Int, _ tableView: UITableView) {
            headers[section].isOpened.toggle()
            tableView.reloadSections([section], with: .none)
        }
        
        func getToggleStatus(section: Int) -> Bool {
            return headers[section].isOpened
        }
        
        func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: ChatListFooterView.identifier)
            if section == 2 {
                return nil
            }
            return footer
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if section == 0 {
                return headers[section].isOpened ? channelList.count+1 : 0
            } else if section == 1 {
                return headers[section].isOpened ? directMessage.count+1 : 0
            } else {
                return 1
            }
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if indexPath.section == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelTableViewCell.identifier, for: indexPath) as? ChannelTableViewCell else { return .init() }
                if indexPath.row == channelList.count {
                    cell.setImage(image:"plus", title: "채널 추가")
                    return cell
                }
                let channel = channelList[indexPath.row]
                cell.config(title: channel.title, newMessageCount: channel.newMessageCount)
                return cell
            } else if indexPath.section == 1 {
                if indexPath.row == directMessage.count {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelTableViewCell.identifier, for: indexPath) as? ChannelTableViewCell else { return .init() }
                    cell.setImage(image: "plus", title: "새 메시지 시작")
                    return cell
                }
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DirectMessageTableViewCell.identifier, for: indexPath) as? DirectMessageTableViewCell else { return .init() }
                let profile = directMessage[indexPath.row]
                cell.config(profile: profile.profileImage, name: profile.nickname, newMessageCount: profile.newMessageCount)
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
    }
}
