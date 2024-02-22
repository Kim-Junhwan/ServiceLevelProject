//
//  ChannelTableViewCell.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/22.
//

import UIKit
import SwiftUI

class ChannelTableViewCell: UITableViewCell {
    
    static let identifier = "ChannelTableViewCell"
    
    private let iconImageView: UIImageView = {
        let indicatorImage = UIImage(systemName: "number")?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: indicatorImage)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .black
        var config = UIImage.SymbolConfiguration(font: .boldSystemFont(ofSize: 10))
        imageView.preferredSymbolConfiguration = config
        return imageView
    }()
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.font = CustomFont.body.uifont
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.setContentHuggingPriority(.init(252), for: .horizontal)
        return label
    }()
    
    private let newMessageIcon: PaddingLabel = {
        let label = PaddingLabel(padding: .init(top: 2, left: 6, bottom: 2, right: 6))
        label.font = CustomFont.caption.uifont
        label.textColor = .white
        label.backgroundColor = .brandGreen
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.setContentHuggingPriority(.init(253), for: .horizontal)
        return label
    }()
    
    lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [iconImageView, titleLabel, newMessageIcon])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 16
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func configureView() {
        addSubview(contentStackView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: 18),
            iconImageView.heightAnchor.constraint(equalToConstant: 18),
            contentStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    func config(title: String, newMessageCount: Int) {
        titleLabel.text = title
        newMessageIcon.isHidden = (newMessageCount == 0)
        newMessageIcon.text = "\(newMessageCount)"
        newMessageCountLayout(count: newMessageCount)
    }
    
    func setImage(image: String, title: String) {
        iconImageView.image = UIImage(systemName: image)
        titleLabel.text = title
        newMessageCountLayout(count: 0)
    }
    
    private func newMessageCountLayout(count: Int) {
        titleLabel.textColor = count == 0 ? .textSecondary : .black
        titleLabel.font = count == 0 ? CustomFont.body.uifont : CustomFont.bodyBold.uifont
        iconImageView.preferredSymbolConfiguration = count == 0 ? .init(font: .systemFont(ofSize: 10)) : .init(font: .boldSystemFont(ofSize: 10))
        iconImageView.tintColor = count == 0 ? .textSecondary : .black
        newMessageIcon.isHidden = count == 0
    }
}
