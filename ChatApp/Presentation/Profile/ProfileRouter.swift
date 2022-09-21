//
//  ProfileRouter.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 21.04.2022.
//

import Foundation
import UIKit

protocol ProfileRouterProtocol {
    func close()
    func showAlert(title: String?, message: String?, actions: [UIAlertAction])
    func openRemoteGallery(delegate: AvatarGalleryDelegate)
}

final class ProfileRouter: ProfileRouterProtocol {
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func close() {
       viewController?.dismiss(animated: true, completion: nil)
    }
    
    func showAlert(title: String?, message: String?, actions: [UIAlertAction]) {
        guard let vc = self.viewController else { return }
        vc.showAlert(title: title, message: message, actions: actions)
    }
    
    func openRemoteGallery(delegate: AvatarGalleryDelegate) {
        let avatarGallery = AvatarGalleryViewController()
        avatarGallery.delegate = delegate
        avatarGallery.modalPresentationStyle = .pageSheet
        viewController?.present(avatarGallery, animated: true, completion: nil)
    }
 }
