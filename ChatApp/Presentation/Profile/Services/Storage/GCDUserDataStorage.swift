//
//  GSDUserdataStorage.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 19.03.2022.
//

import Foundation
import UIKit

class GCDUserDataStorage: UserDataStorageable {

    private struct Constants {
        static let avatarFileName = "avatar.jpg"
        static let userInfoFileName = "userInfo.json"
    }

    private let fileManager = FileManager.default
    private let queue = DispatchQueue.global(qos: .userInitiated)

    func saveUserInfo(avatar image: UIImage?,
                      userInfo info: UserInfo,
                      completion: @escaping (Bool) -> Void) {
        queue.async { [weak self] in
            // из-за того что операция выполняется очень быстро, добавила задержку, чтоб можно было увидеть лоадер
            sleep(1)
            guard let self = self else { return }
            do {
                try self.saveAvatar(image: image)
                try self.saveUserInfo(user: info)
                completion(true)
            } catch {
                completion(false)
            }
        }
    }

    func fetchUserInfo(completion: @escaping (Result<User, Error>) -> Void) {
        queue.async { [weak self] in
            guard let self = self else { return }
            do {
                let avatar = try self.fetchAvatar()
                let userInfo = try self.fetchUserInfo()
                let user = User(userInfo: userInfo, avatar: avatar)
                completion(.success(user))
            } catch {
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Internal Metods
private extension GCDUserDataStorage {
    func saveAvatar(image: UIImage?) throws {
        guard let image = image else { return }
        let fileAvatarURL = try fileURL(fileName: Constants.avatarFileName)
        if let data = image.jpegData(compressionQuality: 1) {
            try data.write(to: fileAvatarURL)
        }
    }

    func saveUserInfo(user: UserInfo) throws {
        let fileUserInfoURL = try fileURL(fileName: Constants.userInfoFileName)
        let data = try JSONEncoder().encode(user)
        try data.write(to: fileUserInfoURL)
    }

    func fetchAvatar() throws -> UIImage? {
        let fileAvatarURL = try fileURL(fileName: Constants.avatarFileName)
        
        let imageData = try Data(contentsOf: fileAvatarURL)
        let image = UIImage(data: imageData)
        return image
    }

    func fetchUserInfo() throws -> UserInfo {
        let fileUserInfoURL = try fileURL(fileName: Constants.userInfoFileName)
        let userInfoData = try Data(contentsOf: fileUserInfoURL)
        let userInfo = try JSONDecoder().decode(UserInfo.self, from: userInfoData)
        return userInfo
    }

    func fileURL(fileName: String) throws -> URL {
        let documentDirectory = try fileManager.url(for: .documentDirectory,
                                                    in: .userDomainMask,
                                                    appropriateFor: nil,
                                                    create: false)
        return documentDirectory.appendingPathComponent(fileName)
    }
}
