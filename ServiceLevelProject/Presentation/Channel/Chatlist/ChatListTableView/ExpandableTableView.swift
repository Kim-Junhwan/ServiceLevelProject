//
//  ExpandableTableView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/25.
//

import UIKit

enum ExpandableSection: Int {
    case channel
    case dm
    case addMember
}

struct ButtonCell: Hashable {
    let title: String
    let icon: String
}

class ExpandableTableView: UIView {
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ChatListHeaderView.self, forHeaderFooterViewReuseIdentifier: ChatListHeaderView.identifier)
        tableView.register(ChatListFooterView.self, forHeaderFooterViewReuseIdentifier: ChatListFooterView.identifier)
        tableView.register(ChannelTableViewCell.self, forCellReuseIdentifier: ChannelTableViewCell.identifier)
        tableView.register(DirectMessageTableViewCell.self, forCellReuseIdentifier: DirectMessageTableViewCell.identifier)
        tableView.sectionHeaderTopPadding = 1
        tableView.separatorStyle = .none
        return tableView
    }()
    
    lazy var dataSource: UITableViewDiffableDataSource<ExpandableSection, AnyHashable>? = makeDatasource()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        addSubview(tableView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func makeDatasource() -> UITableViewDiffableDataSource<ExpandableSection, AnyHashable> {
        UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, item in
            guard let section = ExpandableSection(rawValue: indexPath.section) else { fatalError() }
            switch section {
            case .channel:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelTableViewCell.identifier, for: indexPath) as? ChannelTableViewCell else { return .init() }
                if let channelItem = item as? ChannelListItemModel {
                    cell.config(title: channelItem.name, newMessageCount: channelItem.newMessageCount)
                } else if let button = item as? ButtonCell  {
                    cell.setImage(image: button.icon, title: button.title)
                }
                return cell
            case .dm:
                if let cell = tableView.dequeueReusableCell(withIdentifier: ChannelTableViewCell.identifier, for: indexPath) as? ChannelTableViewCell {
                    if let button = item as? ButtonCell {
                        cell.setImage(image: button.icon, title: button.title)
                        return cell
                    }
                }
                if let cell = tableView.dequeueReusableCell(withIdentifier: DirectMessageTableViewCell.identifier, for: indexPath) as? DirectMessageTableViewCell {
                    if let dmItem = item as? DMRoomItemModel {
                        cell.config(profile: dmItem.user.profileImagePath, name: dmItem.user.nickname, newMessageCount: dmItem.newMessageCount)
                        return cell
                    }
                }
                return .init()
            case .addMember:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ChannelTableViewCell.identifier, for: indexPath) as? ChannelTableViewCell, let button = item as? ButtonCell else { return .init() }
                cell.setImage(image: button.icon, title: button.title)
                return cell
            }
        }
    }
    
    func updateTableView(channelOpen: Bool, channelList: [ChannelListItemModel], dmOpen: Bool, dmList: [DMRoomItemModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<ExpandableSection, AnyHashable>()
        snapshot.appendSections([.channel, .dm, .addMember])
        if channelOpen {
            snapshot.appendItems(channelList, toSection: .channel)
            snapshot.appendItems([ButtonCell(title: "채널추가", icon: "plus")], toSection: .channel)
        }
        if dmOpen {
            snapshot.appendItems(dmList, toSection: .dm)
            snapshot.appendItems([ButtonCell(title: "새 메시지 시작", icon: "plus")], toSection: .dm)
        }
        snapshot.appendItems([ButtonCell(title: "팀원 추가", icon: "plus"),], toSection: .addMember)
        dataSource?.apply(snapshot)
    }
}
