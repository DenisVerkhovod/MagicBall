//
//  NetworkManager.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 8/27/19.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import Foundation

/**
 An object which handles all network calls. All requests must be sent through this object.
 */
protocol NetworkManagerProtocol {

    /**
     Fetch an answer.
     - Parameter completion: Will be called with Swift.Result as a parameter when the answer was fetched.
     - Returns: instance of the URLSessionDataTask.
     */
    @discardableResult func getAnswer(
        completion: @escaping (Result<Decision, NetworkError>
        ) -> Void) -> URLSessionDataTask?

}

final class NetworkManager: NetworkManagerProtocol {

    @discardableResult func getAnswer(
        completion: @escaping (Result<Decision, NetworkError>) -> Void
        ) -> URLSessionDataTask? {
        let mainQueue = DispatchQueue.main
        let task = ApiRequest<MagicBallApiSchema>().request(.jsonAnswer) { result in
            switch result {
            case let .success(data):
                do {
                    let decision = try JSONDecoder().decode(Decision.self, from: data)
                    mainQueue.async {
                        completion(.success(decision))
                    }
                } catch let error {
                    mainQueue.async {
                        completion(.failure(.decodeError(error)))
                    }
                }

            case let .failure(error):
                mainQueue.async {
                    completion(.failure(error))
                }
            }
        }

        return task
    }
}
