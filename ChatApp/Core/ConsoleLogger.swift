//
//  ConsoleLogger.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 18.02.2022.
//

import Foundation

final class ConsoleLogger {
    static var isEnabled: Bool = false

    static func log(message: String) {
        guard isEnabled else { return }
        print(message)
    }
}
