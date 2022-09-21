//
//  AvatarImageRequest.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 25.04.2022.
//

import UIKit

final class AvatarImageRequest: IRequest {
    private let page: Int
    private let perPage: Int
    
    lazy var urlRequest: URLRequest? = {
        var components = URLComponents()
        components.scheme = "http"
        components.host = "pixabay.com"
        components.path = "/api"
        components.queryItems = [
            URLQueryItem(name: "key", value: "26929790-7a72a00acb6206a71e4b220b2"),
            URLQueryItem(name: "safesearch", value: "true"),
            URLQueryItem(name: "per_page", value: String(perPage)),
            URLQueryItem(name: "page", value: String(page))
        ]
        guard let url = components.url else { return nil }
        return URLRequest(url: url)
    }()
    
    init(page: Int, perPage: Int) {
        self.page = page
        self.perPage = perPage
    }
}
