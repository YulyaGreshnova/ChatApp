//
//  UserServies.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 23.03.2022.
//

import Foundation
import UIKit

class UserService {
    private let userGCDStorage: UserDataStorageable
    private(set) var currentUser: User
    private let userDefaults = UserDefaults()
    let userId: String

    static let shared = UserService()

    private init() {
        userGCDStorage = GCDUserDataStorage()

        if let savedIdData = userDefaults.object(forKey: "userId") as? String {
            userId = savedIdData
        } else {
            userId = UUID().uuidString
            userDefaults.setValue(userId, forKey: "userId")
        }
        
        self.currentUser = User(userInfo: UserInfo(fullName: "Имя Фамилия",
                                                   detailInfo: "О себе"),
                                avatar: nil)
    }

    func saveGCD(avatar: UIImage?, userInfo: UserInfo, completion: @escaping (Bool) -> Void) {
        userGCDStorage.saveUserInfo(avatar: avatar, userInfo: userInfo) { isSuccess in
            completion(isSuccess)
        }
    }

    func fetchGCD(completion: @escaping (User) -> Void) {
        userGCDStorage.fetchUserInfo { [weak self] (result) in
            guard let self = self else { return }

            if let user = try? result.get() {
                self.currentUser = user
                completion(user)
                return
            }
            completion(self.currentUser)
        }
    }
}
