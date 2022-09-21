//
//  RequestSender.swift
//  ChatApp
//
//  Created by Yulya Greshnova on 25.04.2022.
//

import UIKit

final class RequestSender: IRequestSender {
    private let session = URLSession(configuration: .default)

    func send<Parser>(config: RequestConfig<Parser>,
                      completion: @escaping (Result<Parser.Model, Error>) -> Void) {
        guard let urlRequest = config.request.urlRequest else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
                completion(.failure(NetworkError.serverError))
            }
            
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                completion(.failure(NetworkError.serverError))
                return
            }
            
            guard let parsedModel = try? config.parser.parse(data: data) else {
                completion(.failure(NetworkError.parsingError))
                return
            }
            
            completion(.success(parsedModel))
        }
        dataTask.resume()
    }
}
