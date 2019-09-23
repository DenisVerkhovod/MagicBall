//
//  NetworkManager.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 8/27/19.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import Foundation

/**
 Network manager handles all network calls. All requests must be sent through this manager.
 */
final class NetworkManager {

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
