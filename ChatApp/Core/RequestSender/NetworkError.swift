//
//  NetworkError.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 27.04.2022.
//

import Foundation

enum NetworkError: Error {
    case serverError
    case invalidURL
    case parsingError
}
