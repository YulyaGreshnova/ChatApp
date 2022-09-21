//
//  IRequestSender.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 25.04.2022.
//

import Foundation

protocol IRequestSender {
    func send<Parser>(config: RequestConfig<Parser>,
                      completion: @escaping (Result<Parser.Model, Error>) -> Void)
}
