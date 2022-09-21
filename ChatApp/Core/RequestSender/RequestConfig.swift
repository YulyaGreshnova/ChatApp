//
//  RequestConfig.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 25.04.2022.
//

import Foundation

struct RequestConfig<Parser: IParser> {
    let request: IRequest
    let parser: Parser
}
