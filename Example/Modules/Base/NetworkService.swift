//
//  NetworkService.swift
//  XRouter_Example
//
//  Created by jowsing on 2024/11/8.
//

import Foundation
import X_Router

public protocol NetworkService: RoutableService {
    @discardableResult
    static func request(_ request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask
}

public extension NetworkService {
    
    static var name: String {
        return String(describing: self)
    }
}
