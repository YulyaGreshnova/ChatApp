//
//  ConversationViewController.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 05.03.2022.
//

import UIKit
import CoreData

final class ConversationViewController: UIViewController {
    private let tableView: UITableView
    private let messageProvider: IMessageProvider
    private let conversationTitle: String
    private let conversationDataSource: ConversationDataSource
    private let chatInputView = ChatInputView()
    private var panGestureAnimator: PanGestureAnimator?
    
    init(conversationTitle: String,
         messageProvider: IMessageProvider,
         frcProvider: FRCProvider<DBMessage>,
         userService: UserService) {

        self.messageProvider = messageProvider
        self.conversationTitle = conversationTitle
        tableView = UITableView(frame: .zero, style: .plain)
        conversationDataSource = ConversationDataSource(tableView: tableView,
                                                        frcConversationProvider: frcProvider,
                                                        userService: userService)
        
        super.init(nibName: nil, bundle: nil)
        panGestureAnimator = PanGestureAnimator(view: self.view)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var inputAccessoryView: ChatInputView {
        return chatInputView
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeKeyboardNotifications()
        
        view.backgroundColor = .white
        title = conversationTitle
        setupTableView()
        chatInputView.delegate = self
        messageProvider.startListeningMessages()
    }
}

// MARK: - View configuration
extension ConversationViewController {
    private func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.keyboardDismissMode = .interactive
        tableView.estimatedRowHeight = 65
        tableView.backgroundColor = .systemGroupedBackground
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.dataSource = conversationDataSource
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(ConversationMessageTableViewCell.self,
                           forCellReuseIdentifier: ConversationMessageTableViewCell.cellIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - ChatInputViewDelegate
extension ConversationViewController: ChatInputViewDelegate {
    func didPressSendButton(text: String) {
        messageProvider.createNewMessage(text: text) { [weak self] isSuccess in
            if !isSuccess {
                self?.showFailureMessageCreatingNewMessage()
            }
        }
        chatInputView.updateMessageText(text: "")
    }
}

// MARK: - Keyboard
private extension ConversationViewController {
    func subscribeKeyboardNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(keyboardWillShow(notification:)),
                                       name: UIResponder.keyboardWillShowNotification,
                                       object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard
            let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }
        
        let keyboardViewEndFrame = view.convert(keyboardFrame, from: view.window)
        var contentInsets = tableView.contentInset
        contentInsets.bottom = keyboardViewEndFrame.height

        let duration: TimeInterval = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.0
        UIView.animate(withDuration: duration) {
            self.tableView.contentInset = contentInsets
            self.tableView.scrollIndicatorInsets = contentInsets
        }
    }
}

// MARK: - AlertMessages
private extension ConversationViewController {
    func showFailureMessageCreatingNewMessage() {
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        showAlert(title: "Не удалось отправить сообщение",
                  message: nil,
                  actions: [okAction])
    }
    
    func showFailureMessageLoadingMessages(error: Error) {
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        showAlert(title: "Не удалось загрузить сообщения",
                  message: "\(error)",
                  actions: [okAction])
    }
}
