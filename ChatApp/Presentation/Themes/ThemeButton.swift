//
//  ThemeButton.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 15.03.2022.
//

import UIKit

final class ThemeButton: UIButton {
    private let themeView = UIView()
    private let nameThemeLabel = UILabel()
    private let incommingView = UIView()
    private let outcommingView = UIView()

    override var isSelected: Bool {
        didSet {
            if isSelected {
                themeView.layer.borderWidth = 2
                themeView.layer.borderColor = UIColor(red: 20 / 255, green: 132 / 255, blue: 251 / 255, alpha: 1).cgColor
            } else {
                themeView.layer.borderWidth = 0
                themeView.layer.borderColor = UIColor.clear.cgColor
            }
        }
    }

    init() {
        super.init(frame: .zero)

        setupButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupButton() {
        themeView.layer.cornerRadius = 10
        themeView.translatesAutoresizingMaskIntoConstraints = false
        themeView.isUserInteractionEnabled = false
        addSubview(themeView)

        incommingView.layer.cornerRadius = 8
        incommingView.translatesAutoresizingMaskIntoConstraints = false
        themeView.addSubview(incommingView)

        outcommingView.layer.cornerRadius = 8
        outcommingView.translatesAutoresizingMaskIntoConstraints = false
        themeView.addSubview(outcommingView)

        nameThemeLabel.backgroundColor = .clear
        nameThemeLabel.textColor = .white
        nameThemeLabel.textAlignment = .center
        nameThemeLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameThemeLabel)

        NSLayoutConstraint.activate([
            themeView.topAnchor.constraint(equalTo: topAnchor),
            themeView.leadingAnchor.constraint(equalTo: leadingAnchor),
            themeView.trailingAnchor.constraint(equalTo: trailingAnchor),

            incommingView.topAnchor.constraint(equalTo: themeView.topAnchor, constant: 10),
            incommingView.leadingAnchor.constraint(equalTo: themeView.leadingAnchor, constant: 30),
            incommingView.trailingAnchor.constraint(equalTo: outcommingView.leadingAnchor,
                                                     constant: -10),
            incommingView.heightAnchor.constraint(equalToConstant: 20),

            outcommingView.topAnchor.constraint(equalTo: incommingView.bottomAnchor),
            outcommingView.trailingAnchor.constraint(equalTo: themeView.trailingAnchor, constant: -30),
            outcommingView.bottomAnchor.constraint(equalTo: themeView.bottomAnchor, constant: -10),
            outcommingView.heightAnchor.constraint(equalTo: incommingView.heightAnchor),
            outcommingView.widthAnchor.constraint(equalTo: incommingView.widthAnchor),

            nameThemeLabel.topAnchor.constraint(equalTo: themeView.bottomAnchor, constant: 10),
            nameThemeLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            nameThemeLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameThemeLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func update(with theme: Theme) {
        themeView.backgroundColor = theme.backgroundColor
        nameThemeLabel.text = theme.name
        incommingView.backgroundColor = theme.incommingMessageColor
        outcommingView.backgroundColor = theme.outcommingMessageColor
    }
}
