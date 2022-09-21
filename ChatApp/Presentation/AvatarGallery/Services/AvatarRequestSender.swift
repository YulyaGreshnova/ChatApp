//
//  AvatarRequestSender.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 25.04.2022.
//

import UIKit

final class AvatarRequestSender {
    private let requestSender: IRequestSender
    
    init(requestSender: IRequestSender = RequestSender()) {
        self.requestSender = requestSender
    }
    
    func loadImages(page: Int,
                    perPage: Int,
                    completion: @escaping (Result<[AvatarImageModel], Error>) -> Void) {
        let parser = AvatarImageParser()
        let request = AvatarImageRequest(page: page, perPage: perPage)
        let requestConfig = RequestConfig(request: request, parser: parser)
        
        requestSender.send(config: requestConfig) { result in
            completion(result)
        }
    }
}
