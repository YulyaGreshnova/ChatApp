//
//  AvatarGalleryCellConfiguration.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 25.04.2022.
//

import Foundation
import UIKit

final class AvatarGalleryCell: UICollectionViewCell {
    private let imageView: UIImageView = UIImageView()
    private let activityIndicator = UIActivityIndicatorView()
    static let cellIdentifier = "AvatarGalleryCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .secondarySystemBackground
        activityIndicator.color = .systemGray
        activityIndicator.hidesWhenStopped = true
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    private func setupLayout() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configureWith(viewModel: AvatarImageModel) {
        activityIndicator.startAnimating()
        imageView.loadFromUrl(url: viewModel.imagePreviewURL) { [weak self] (isSuccess) in
            guard let self = self else { return }
            if isSuccess {
                self.activityIndicator.stopAnimating()
            } else {
                self.imageView.image = UIImage(named: "placeholder")
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
}
