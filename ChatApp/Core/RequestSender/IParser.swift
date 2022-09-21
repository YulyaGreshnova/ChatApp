//
//  IParser.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 25.04.2022.
//

import Foundation

protocol IParser {
    associatedtype Model
    func parse(data: Data) throws -> Model? 
}
