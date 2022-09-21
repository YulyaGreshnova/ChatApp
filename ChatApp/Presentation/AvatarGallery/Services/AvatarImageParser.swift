//
//  AvatarImageParser.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 25.04.2022.
//

import UIKit

private struct AvatarImagesResponse: Decodable {
    let items: [AvatarImageModel]
    
    private enum CodingKeys: String, CodingKey {
        case items = "hits"
    }
}

final class AvatarImageParser: IParser {
    func parse(data: Data) throws -> [AvatarImageModel]? {
        let decoder = JSONDecoder()
        let imagesUrl = try decoder.decode(AvatarImagesResponse.self, from: data)
        return imagesUrl.items
    }
}
