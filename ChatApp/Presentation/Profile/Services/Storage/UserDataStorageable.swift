//
//  UserDataStorageable.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 19.03.2022.
//

import Foundation
import UIKit

protocol UserDataStorageable {
    func saveUserInfo(avatar image: UIImage?,
                      userInfo info: UserInfo,
                      completion: @escaping (Bool) -> Void)
    func fetchUserInfo(completion: @escaping (Result<User, Error>) -> Void)
}
