//
//  RoutableHandler.swift
//  XRouter
//
//  Created by jowsing on 2024/10/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation

public protocol RoutableService: NSObject, Routable {
    
    static var name: String { get }
}

extension RoutableService {
    
    public static func register() {
        Router.shared.serviceTypes[name] = Self.self
    }
}
