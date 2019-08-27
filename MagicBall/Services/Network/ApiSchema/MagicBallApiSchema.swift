//
//  MagicBallApiSchema.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 8/27/19.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import Foundation

private extension MagicBallApiSchema {
    enum Configuration {
        static let baseUrl: String = "https://8ball.delegator.com"
        static let defaultQuestion: String = "Some question"
    }
    enum ResponseFormat: String {
        case json = "JSON"
        case xml = "XML"
    }
}

enum MagicBallApiSchema {
    case jsonAnswer
}

extension MagicBallApiSchema: ApiSchemaProtocol {
    var baseURL: String {
        return Configuration.baseUrl
    }
    
    var path: String {
        switch self {
        case .jsonAnswer:
            return "magic/\(ResponseFormat.json.rawValue)/\(Configuration.defaultQuestion)"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .jsonAnswer:
            return .get
        }
    }
}
