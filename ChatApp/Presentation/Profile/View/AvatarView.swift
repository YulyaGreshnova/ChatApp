//
//  AvatarView.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 25.02.2022.
//

import UIKit

final class AvatarView: UIView {

    enum Style {
        case large
        case small

        var fontSize: CGFloat {
            switch self {
            case .large:
                return 120
            case .small:
                return 14
            }
        }

        var letterSpacing: CGFloat {
            switch self {
            case .large:
                return 30
            case .small:
                return 4
            }
        }
    }

    private let imageView = UIImageView()
    private let lettersContainerView = UIView()
    private let firstLetterLabel = UILabel()
    private let secondLetterLabel = UILabel()
    private let style: Style

    var image: UIImage? {
        imageView.image
    }

    init(style: Style) {
        self.style = style

        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        accessibilityIdentifier = "AvatarView"
        clipsToBounds = true

        imageView.isHidden = true
        imageView.contentMode = .scaleAspectFill
        imageView.accessibilityIdentifier = "AvatarImageView"
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)

        lettersContainerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(lettersContainerView)

        firstLetterLabel.text = "M"
        firstLetterLabel.textAlignment = .center
        firstLetterLabel.font = .boldSystemFont(ofSize: style.fontSize)
        firstLetterLabel.translatesAutoresizingMaskIntoConstraints = false
        lettersContainerView.addSubview(firstLetterLabel)

        secondLetterLabel.text = "D"
        secondLetterLabel.textAlignment = .center
        secondLetterLabel.font = .boldSystemFont(ofSize: style.fontSize)
        secondLetterLabel.translatesAutoresizingMaskIntoConstraints = false
        lettersContainerView.addSubview(secondLetterLabel)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),

            lettersContainerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            lettersContainerView.centerXAnchor.constraint(equalTo: centerXAnchor),

            firstLetterLabel.leadingAnchor.constraint(equalTo: lettersContainerView.leadingAnchor),
            firstLetterLabel.topAnchor.constraint(equalTo: lettersContainerView.topAnchor),
            firstLetterLabel.bottomAnchor.constraint(equalTo: lettersContainerView.bottomAnchor),
            // такой отступ подобран для наложения букв с соответсвии с дизайном в фигме
            firstLetterLabel.trailingAnchor.constraint(equalTo: secondLetterLabel.leadingAnchor, constant: style.letterSpacing),

            secondLetterLabel.trailingAnchor.constraint(equalTo: lettersContainerView.trailingAnchor),
            secondLetterLabel.topAnchor.constraint(equalTo: lettersContainerView.topAnchor),
            secondLetterLabel.bottomAnchor.constraint(equalTo: lettersContainerView.bottomAnchor)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }

    func showImage(image: UIImage?) {
        let hasImage = image != nil
        imageView.isHidden = !hasImage
        lettersContainerView.isHidden = hasImage
        imageView.image = image
    }
}
