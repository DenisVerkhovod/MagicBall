//
//  ApiSchemaProtocol.swift
//  MagicBall
//
//  Created by Denis Verkhovod on 8/27/19.
//  Copyright © 2019 Denis Verkhovod. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

/**
 Represents object with api specification.
 */
protocol ApiSchemaProtocol {
    
    /// The API's base URL.
    var baseURL: String { get }
    /// The path to append to baseURL.
    var path: String { get }
    /// The http method to use in request.
    var httpMethod: HTTPMethod { get }
    
}
