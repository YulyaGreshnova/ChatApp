//
//  RequestSenderMock.swift
//  ChatAppTests
//
//  Created by Yulya Greshnova on 16.05.2022.
//

import Foundation
@testable import ChatApp

class RequestSenderMock<T: IParser>: IRequestSender {
    var invokedSend = false
    var invokedSendCount = 0
    var invokedSendParameters: (config: RequestConfig<T>, Void)?
    
    func send<Parser>(config: RequestConfig<Parser>,
                      completion: @escaping (Result<Parser.Model, Error>) -> Void) where Parser: IParser {
        invokedSend = true
        invokedSendCount += 1
        if let castedConfig = config as? RequestConfig<T> {
            invokedSendParameters = (castedConfig, ())
        }
    }
}
