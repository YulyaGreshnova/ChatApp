//
//  MessageTableViewCell.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 05.03.2022.
//

import UIKit

protocol MessageCellConfiguration: AnyObject {
    var message: String? { get set }
    var isIncoming: Bool { get set }
    var name: String? { get set }
    var date: Date { get set }
}

final class ConversationMessageTableViewCell: UITableViewCell, MessageCellConfiguration {

    private let messageView = UIView()
    private let messageLabel = UILabel()
    private let nameLabel = UILabel()
    private var incomingMessageConstraint: NSLayoutConstraint?
    private var outcomingMessageConstraint: NSLayoutConstraint?
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
    
    static let cellIdentifier = "MessageCell"
    
    var message: String? {
        didSet {
            messageLabel.text = message
        }
    }

    var isIncoming: Bool = false {
        didSet {
            if isIncoming {
                incomingMessageConstraint?.isActive = false
                outcomingMessageConstraint?.isActive = true
                messageView.backgroundColor = .white
            } else {
                outcomingMessageConstraint?.isActive = false
                incomingMessageConstraint?.isActive = true
                messageView.backgroundColor = UIColor(red: 215 / 225, green: 253 / 255, blue: 220 / 255, alpha: 1)
            }
        }
    }
    
    var name: String? {
        didSet {
            nameLabel.text = name
            nameLabel.isHidden = name == nil
        }
    }
    
    var date: Date = Date() {
        didSet {
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
        backgroundColor = .systemGroupedBackground

        messageView.translatesAutoresizingMaskIntoConstraints = false
        messageView.layer.cornerRadius = 10
        contentView.addSubview(messageView)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = .systemPurple
        messageView.addSubview(nameLabel)

        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageView.addSubview(messageLabel)
        
        dateLabel.font = .italicSystemFont(ofSize: 13)
        dateLabel.textColor = .systemGray
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        messageView.addSubview(dateLabel)

        incomingMessageConstraint = messageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                                          constant: -16)
        outcomingMessageConstraint = messageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                                          constant: 16)

        NSLayoutConstraint.activate([
            messageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            messageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            messageView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor,
                                               multiplier: 0.75),
            
            nameLabel.topAnchor.constraint(equalTo: messageView.topAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: messageView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -8),

            messageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            messageLabel.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -8),
            messageLabel.leadingAnchor.constraint(equalTo: messageView.leadingAnchor, constant: 8),
            
            dateLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 2),
            dateLabel.leadingAnchor.constraint(greaterThanOrEqualTo: messageView.leadingAnchor, constant: 4),
            dateLabel.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: -8),
            dateLabel.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -4)
        ])
    }
}
