//
//  UserInfo.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 19.03.2022.
//

import Foundation
import UIKit

struct UserInfo: Codable {
    let fullName: String?
    let detailInfo: String?
}

struct User {
    let userInfo: UserInfo
    let avatar: UIImage?
}
