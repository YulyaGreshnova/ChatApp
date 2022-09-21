//
//  Avatar.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 25.04.2022.
//

import UIKit

struct AvatarImageModel: Decodable {
    let imagePreviewURL: URL
    let imageURL: URL
    
    private enum CodingKeys: String, CodingKey {
        case imagePreviewURL = "previewURL"
        case imageURL = "webformatURL"
    }
}
