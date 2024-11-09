//
//  Routable.swift
//  XRouter
//
//  Created by jowsing on 2024/10/16.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation

public protocol Routable: Registrable {
    
    static var paths: [String] { get }
}

extension Routable {
    
    static func register() {
        paths.forEach { path in
            Router.shared.register(Self.self, forPath: path)
        }
    }
}
