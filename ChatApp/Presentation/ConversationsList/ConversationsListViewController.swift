//
//  ViewController.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 18.02.2022.
//

import UIKit
import FirebaseFirestore
import CoreData

final class ConversationsListViewController: UIViewController {

    private let tableView: UITableView
    private let channelProvider: IChannelsProvider
    private let conversationsDataSource: ConversationsDataSource
    var router: ConversationsRouterProtocol?
    private var panGestureAnimator: PanGestureAnimator?
    
    init(frcProvider: FRCProvider<DBChannel>,
         channelProvider: IChannelsProvider) {
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        conversationsDataSource = ConversationsDataSource(tableView: tableView,
                                                          frcConversationsProvider: frcProvider)
        self.channelProvider = channelProvider
        super.init(nibName: nil, bundle: nil)
        conversationsDataSource.delegate = self
        router = ConversationsRouter(viewController: self)
        panGestureAnimator = PanGestureAnimator(view: self.view)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Channels"
        view.backgroundColor = .white

        setupBarButtonView()
        setupTableView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        channelProvider.stopListeningChannels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        channelProvider.startListeningChannels()
    }
}

// MARK: - View configuration

private extension ConversationsListViewController {
    func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 65

        tableView.dataSource = conversationsDataSource
        tableView.delegate = self
        tableView.register(ConversationTableViewCell.self,
                           forCellReuseIdentifier: ConversationTableViewCell.cellIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    func setupBarButtonView() {
        let avatarView = AvatarView(style: .small)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(openProfile))
        avatarView.addGestureRecognizer(tapRecognizer)
        avatarView.isAccessibilityElement = true
        avatarView.backgroundColor = UIColor(red: 228 / 255, green: 232 / 255, blue: 43 / 255, alpha: 1)
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarView.widthAnchor.constraint(equalToConstant: 40),
            avatarView.heightAnchor.constraint(equalToConstant: 40)
        ])
        let rightBarButtonItem = UIBarButtonItem(customView: avatarView)
        rightBarButtonItem.accessibilityLabel = "avatarViewBarButtonItem"
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"),
                                                style: .plain,
                                                target: self,
                                                action: #selector(openSettings))
        
        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showNewChannelAlert))
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItems = [addBarButtonItem, rightBarButtonItem]
    }
}

// MARK: - Internal Methods

private extension ConversationsListViewController {
    @objc func openProfile() {
        router?.navigate(to: .profile)
    }

    @objc func openSettings() {
        router?.navigate(to: .settings(self))
    }
    
    @objc func showNewChannelAlert() {
        let allertContoller = UIAlertController(title: "Создание нового канала",
                                                message: nil,
                                                preferredStyle: .alert)
        allertContoller.addTextField { (textField) in
            textField.placeholder = "Введите название канала"
        }
        allertContoller.addAction(
            UIAlertAction(
                title: "Создать",
                style: .default,
                handler: { _ in
                    guard let name = allertContoller.textFields?.first?.text else { return }
                    self.addNewChannel(with: name)
                }))
        allertContoller.addAction(UIAlertAction(title: "Отмена",
                                                style: .cancel,
                                                handler: nil))
        present(allertContoller, animated: true, completion: nil)
    }
   
    func addNewChannel(with name: String) {
        if name.isEmpty {
            router?.navigate(to: .emptyChannelNameError)
            return
        }
        channelProvider.createNewChannel(name: name) {[weak self] (isSuccess) in
            if !isSuccess {
                self?.router?.navigate(to: .failureMessageAddingChannel)
            }
        }
    }
}

// MARK: - ConversationsDataSourceDelegate
extension ConversationsListViewController: ConversationsDataSourceDelegate {
    func didDeleteChannel(id: String) {
        channelProvider.deleteChannel(id: id) { [weak self] (isSuccess) in
            if !isSuccess {
                self?.router?.navigate(to: .failureMessageDeletingChannel)
            }
        }
    }
}

// MARK: - TableViewDelegate

extension ConversationsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let channel = conversationsDataSource.getChannel(indexPath: indexPath)
        guard let channelId = channel.identifier,
              let channelName = channel.name else { return }
        let conversationInput = ConversationInput(id: channelId, title: channelName)
        
        router?.navigate(to: .conversation(conversationInput))
    }
}

// MARK: - ThemesDelegate
extension ConversationsListViewController: ThemesViewDelegate {
    func didChooseTheme(theme: Theme) {
         tableView.backgroundColor = theme.backgroundColor
    }
}
