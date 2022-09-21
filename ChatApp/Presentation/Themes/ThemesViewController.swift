//
//  ThemesViewController.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 15.03.2022.
//

import UIKit

protocol ThemesViewDelegate: AnyObject {
    func didChooseTheme(theme: Theme)
}

final class ThemesViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private var buttons: [ThemeButton] = []
    private let themes: [Theme] = [
        Theme(name: "Classic",
                             backgroundColor: .systemGroupedBackground,
                             incommingMessageColor: .white,
                             outcommingMessageColor: UIColor(red: 215 / 225, green: 253 / 255, blue: 220 / 255, alpha: 1)),
        Theme(name: "Day",
                             backgroundColor: UIColor(red: 192 / 255, green: 157 / 255, blue: 252 / 255, alpha: 1),
                             incommingMessageColor: .white,
                             outcommingMessageColor: UIColor(red: 102 / 255, green: 132 / 255, blue: 255 / 255, alpha: 1)),
        Theme(name: "Night",
                             backgroundColor: UIColor(red: 144 / 255, green: 148 / 255, blue: 210 / 255, alpha: 1),
                             incommingMessageColor: UIColor(red: 245 / 255, green: 245 / 255, blue: 245 / 255, alpha: 1),
                             outcommingMessageColor: UIColor(red: 144 / 255, green: 138 / 255, blue: 138 / 255, alpha: 1))
    ]

    weak var delegate: ThemesViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Settings"

        setupBarButtonView()
        setupView()
    }

}

// MARK: - Internal Methods
private extension ThemesViewController {

    // данную кнопку добавила, так как она присутсвует в макете из задания, но здесь данная кнопка лишняя, так как окно не модальное
    func setupBarButtonView() {
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                 target: self,
                                                 action: #selector(close))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    func setupView() {
        scrollView.backgroundColor = UIColor(red: 18 / 255, green: 55 / 255, blue: 99 / 255, alpha: 1)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 30
        scrollView.addSubview(stackView)

        for theme in themes {
            let button = ThemeButton()
            buttons.append(button)
            button.update(with: theme)
            button.addTarget(self, action: #selector(chooseThemeButton), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 32),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -32),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 32),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -32)
        ])
    }

    @objc func close() {
        navigationController?.popViewController(animated: true)
    }

    @objc func chooseThemeButton(_ sender: ThemeButton) {
        var selectedIndex: Int?
        for index in buttons.indices {
            let button = buttons[index]
            if button.isSelected {
                button.isSelected = false
            }
            if sender === button {
                selectedIndex = index
            }
        }
        guard let index = selectedIndex else { return }

        sender.isSelected = true
        delegate?.didChooseTheme(theme: themes[index])
    }
}
