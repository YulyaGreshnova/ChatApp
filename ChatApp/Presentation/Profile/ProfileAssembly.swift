//
//  ProfileAssembly.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 13.05.2022.
//

import UIKit

final class ProfileAssembly {
    func buildViewContoller() -> UIViewController {
        let viewController = ProfileViewController(userService: UserService.shared)
        let router = ProfileRouter(viewController: viewController)
        viewController.router = router
        
        return viewController
    }
}
