//
//  NetworkService.swift
//  XRouter_Example
//
//  Created by jowsing on 2024/11/8.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import XRouter

protocol NetworkService: RoutableService {
    @discardableResult
    static func request(_ request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask
}

extension NetworkService {
    
    static var name: String { return "NetworkService" }
}

class HTTPService: NSObject, NetworkService {
    
    @discardableResult
    static func request(_ request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(error ?? NSError(domain: "", code: 404)))
            }
        }
        task.resume()
        return task
    }
}
