//
//  UIViewController+Alert.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 30.03.2022.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String?,
                   message: String?,
                   actions: [UIAlertAction],
                   preferredStyle: UIAlertController.Style = .alert) {
        
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: preferredStyle)
        for action in actions {
            alertController.addAction(action)
        }
        present(alertController, animated: true, completion: nil)
    }
}
