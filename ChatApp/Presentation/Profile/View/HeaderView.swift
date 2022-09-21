//
//  HeaderView.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 25.02.2022.
//

import UIKit

protocol HeaderViewDelegate: AnyObject {
    func didPressCloseButton()
}

final class HeaderView: UIView {

    private let titleLabel = UILabel()
    private let closeButton = UIButton(type: .system)
    weak var delegate: HeaderViewDelegate?

    init() {
        super.init(frame: .zero)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        accessibilityIdentifier = "HeaderView"
        titleLabel.text = "My Profile"
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.boldSystemFont(ofSize: 26)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.setContentHuggingPriority(.defaultLow - 1, for: .horizontal)
        addSubview(titleLabel)

        closeButton.setTitle("Close", for: .normal)
        closeButton.addTarget(self, action: #selector(pressCloseButton), for: .touchUpInside)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(closeButton)

        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(greaterThanOrEqualTo: closeButton.leadingAnchor, constant: -8),

            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            closeButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    @objc func pressCloseButton() {
        delegate?.didPressCloseButton()
    }
}
