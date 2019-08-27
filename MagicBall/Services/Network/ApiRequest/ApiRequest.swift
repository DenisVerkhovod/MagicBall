//
//  ApiRequest.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 8/27/19.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case invalidUrl
    case badResponse(Int)
    case requestFailed(Error)
    case decodeError(Error)
}

final class ApiRequest<ApiSchema: ApiSchemaProtocol> {
    /**
     The request to send to the server
     
     - Parameter schema: The object which conform to ApiSchemaProtocol
     - Parameter completion: Will be called on server response
     */
    @discardableResult
    func request(_ schema: ApiSchema, completion: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask? {
        guard let urlRequest = configureRequest(schema) else {
            completion(.failure(.invalidUrl))
            return nil
        }
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest) { data, response, error in
            if let requestError = error {
                completion(.failure(.requestFailed(requestError)))
                return
            }
            if
                let response = response as? HTTPURLResponse,
                !(200...299).contains(response.statusCode) {
                completion(.failure(.badResponse(response.statusCode)))
                return
            }
            if let responseData = data {
                completion(.success(responseData))
            }
        }
        task.resume()
        return task
    }
    
    /// Configure a request according api schema
    private func configureRequest(_ schema: ApiSchemaProtocol) -> URLRequest? {
        guard
            let url = URL(string: schema.baseURL)?
                .appendingPathComponent(schema.path)
            else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = schema.httpMethod.rawValue
        return request
    }
}
