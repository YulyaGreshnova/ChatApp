//
//  AppDelegate.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 18.02.2022.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        ConsoleLogger.isEnabled = false

        FirebaseApp.configure()
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        
        UserService.shared.fetchGCD { _ in }
        
        let viewController = ConversationsAssembly().buildViewController()
        let navigationController = UINavigationController(rootViewController: viewController)

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        return true
    }

}
