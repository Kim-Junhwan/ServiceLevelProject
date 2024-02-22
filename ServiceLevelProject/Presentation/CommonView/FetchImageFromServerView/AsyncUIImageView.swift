//
//  AsyncUIImageView.swift
//  ServiceLevelProject
//
//  Created by JunHwan Kim on 2024/02/22.
//

import UIKit
import Combine

class AsyncUIImageView: UIView {
    let fetchImageModel: FetchImageModel
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let placeholder: UIImage
    private var cancellableBag = Set<AnyCancellable>()
    lazy var activityView: UIActivityIndicatorView = .init(frame: self.frame)
    
    init(placeholder: UIImage) {
        fetchImageModel = .init(url: nil)
        self.placeholder = placeholder
        super.init(frame: .zero)
        bindFetchModel()
        configureView()
        setConstraints()
    }
    
    init(url: String?, placeholder: UIImage) {
        fetchImageModel = .init(url: url)
        self.placeholder = placeholder
        super.init(frame: .zero)
        bindFetchModel()
        configureView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        addSubview(imageView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func bindFetchModel() {
        fetchImageModel.$imageState
            .sink { fetchState in
                switch fetchState {
                case .empty:
                    self.imageView.image = self.placeholder
                case .loading:
                    self.addSubview(self.activityView)
                    self.activityView.startAnimating()
                case .success(_, let image):
                    self.imageView.image = image
                case .failure(_):
                    self.imageView.image = UIImage(systemName: "exclamationmark.triangle.fill")
                }
            }
            .store(in: &cancellableBag)
    }
    
}
