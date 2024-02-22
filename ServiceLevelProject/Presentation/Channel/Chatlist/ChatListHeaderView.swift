//
//  ChatListHeaderView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/21.
//

import UIKit

protocol ChatListHeaderViewDelegate: AnyObject{
    func tapHeader(section: Int, _ tableView: UITableView)
    func getToggleStatus(section: Int) -> Bool
}

class ChatListHeaderView: UITableViewHeaderFooterView {
    
    static let identifier = "ChatListSectionHeader"
    var section: Int = 0
    var isOpened: Bool = false
    weak var delegate: ChatListHeaderViewDelegate?
    weak var tableView: UITableView?

    private let titileLabel: UILabel = {
       let label = UILabel()
        label.font = CustomFont.title2.uifont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let indicatorImageView: UIImageView = {
        let indicatorImage = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
        
        let imageView = UIImageView(image: indicatorImage)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .black
        var config = UIImage.SymbolConfiguration(font: .boldSystemFont(ofSize: 10))
        imageView.preferredSymbolConfiguration = config
        return imageView
    }()
    
    lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titileLabel, indicatorImageView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        return stackView
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureView()
        setConstraints()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleOpen)))
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.indicatorImageView.transform = .init()
        //self.indicatorImageView.transform = self.indicatorImageView.transform.rotated(by: .pi/(self.isOpened ? -2 : 2))
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear) {
            self.indicatorImageView.transform = self.indicatorImageView.transform.rotated(by: .pi/(self.isOpened ? 2 : -2))
            self.contentStackView.layoutIfNeeded()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        delegate = nil
        self.tableView = nil
    }
    
    private func configureView() {
        addSubview(contentStackView)
        addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(toggleOpen)))
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            indicatorImageView.widthAnchor.constraint(equalToConstant: 20),
            indicatorImageView.heightAnchor.constraint(equalToConstant: 14),
            contentStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -23)
        ])
    }
    
    func configHeader(title: String, section: Int, tableView: UITableView, isOpened: Bool) {
        titileLabel.text = title
        self.section = section
        self.tableView = tableView
        self.isOpened = isOpened
    }
    
   @objc private func toggleOpen() {
        guard let delegate, let tableView else { return }
        delegate.tapHeader(section: section, tableView)
    }
}

class ChatListFooterView: UITableViewHeaderFooterView {
    static let identifier = "ChatListSectionFooter"
    
    private let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .seperator
        return view
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        addSubview(separatorView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1.0),
            separatorView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
