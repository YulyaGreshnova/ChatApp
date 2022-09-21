//
//  ConversationsRouter.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 21.04.2022.
//

import Foundation
import UIKit

protocol ConversationsRouterProtocol {
    func navigate(to destination: ConversationsRouterDestination)
}

enum ConversationsRouterDestination {
    case conversation(ConversationInput)
    case profile
    case settings(ThemesViewDelegate)
    case failureMessageAddingChannel
    case failureMessageDeletingChannel
    case emptyChannelNameError
}

final class ConversationsRouter: NSObject, ConversationsRouterProtocol {
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func navigate(to destination: ConversationsRouterDestination) {
        switch destination {
        case .profile:
            let profileViewController = ProfileAssembly().buildViewContoller()
            profileViewController.modalPresentationStyle = .custom
            profileViewController.transitioningDelegate = self
            viewController?.present(profileViewController, animated: true, completion: nil)

        case .settings(let themesViewDelegate):
            let themesViewController = ThemesViewController()
            themesViewController.delegate = themesViewDelegate
            viewController?.navigationController?.pushViewController(themesViewController, animated: true)
            
        case .conversation(let conversationInput):
            let conversationViewController = ConversationAssembly().buildViewController(conversationInput: conversationInput)
            viewController?.navigationController?.pushViewController(conversationViewController, animated: true)
            
        case .failureMessageAddingChannel:
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            viewController?.showAlert(title: "Не удалось создать канал",
                      message: nil,
                      actions: [okAction])
            
        case .failureMessageDeletingChannel:
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            viewController?.showAlert(title: "Не удалось удалить канал",
                      message: nil,
                      actions: [okAction])
        
        case .emptyChannelNameError:
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            viewController?.showAlert(title: "Ошибка",
                      message: "Укажите имя канала",
                      actions: [okAction])
        }
    }
}

extension ConversationsRouter: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        SpinPresentationController(animationDuration: 0.7, animationType: .present)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        SpinPresentationController(animationDuration: 1, animationType: .dismiss)
    }
}
