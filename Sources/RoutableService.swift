//
//  RoutableHandler.swift
//  XRouter
//
//  Created by jowsing on 2024/10/17.
//

import Foundation

public protocol RoutableService: NSObject, Registrable {
    
    static var name: String { get }
}

extension RoutableService {
    
    public static func register() {
        Router.shared.serviceTypes[name] = Self.self
    }
}
