//
//  ConversationTableViewCell.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 04.03.2022.
//

import UIKit

protocol ConversationCellConfiguration: AnyObject {

    var name: String? { get set }
    var message: String? { get set }
    var date: Date? { get set }
}

final class ConversationTableViewCell: UITableViewCell, ConversationCellConfiguration {
    private let nameLabel = UILabel()
    private let messageLabel = UILabel()
    private let dateLabel = UILabel()

    private static let dateFormatterToday: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    private static let dateFormatterForPast: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return formatter
    }()
    
    static let cellIdentifier = "ConversationCell"

    var name: String? {
        didSet {
            if let name = self.name {
                nameLabel.text = name
            } else {
                nameLabel.text = "No name"
                nameLabel.textColor = .systemGray3
            }
        }
    }

    var message: String? {
        didSet {
            if let message = self.message {
                messageLabel.text = message
            } else {
                messageLabel.text = "No message yet"
                messageLabel.textColor = .systemGray
                messageLabel.font = .italicSystemFont(ofSize: Constants.messageFontSize)
            }
        }
    }

    var date: Date? {
        didSet {
            guard let date = self.date else { return }

            if Calendar.current.isDateInToday(date) {
                dateLabel.text = Self.dateFormatterToday.string(from: date)
            } else {
                dateLabel.text = Self.dateFormatterForPast.string(from: date)
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        nameLabel.font = .boldSystemFont(ofSize: Constants.nameFontSize)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)

        dateLabel.textColor = .systemGray
        dateLabel.font = .systemFont(ofSize: Constants.dateFontSize)
        dateLabel.setContentCompressionResistancePriority(.defaultHigh + 1, for: .horizontal)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dateLabel)

        messageLabel.font = .systemFont(ofSize: Constants.messageFontSize)
        messageLabel.textColor = .black
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(messageLabel)

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),

            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(greaterThanOrEqualTo: nameLabel.trailingAnchor,
                                                constant: 8),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                constant: -8),

            messageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            messageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        nameLabel.textColor = .black
        nameLabel.font = .boldSystemFont(ofSize: Constants.nameFontSize)
        messageLabel.font = .systemFont(ofSize: Constants.messageFontSize)
        messageLabel.textColor = .black
        dateLabel.text = nil
    }
}

struct Constants {
    static let messageFontSize: CGFloat = 13
    static let nameFontSize: CGFloat = 15
    static let dateFontSize: CGFloat = 15
}
