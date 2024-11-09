//
//  RoutableViewController.swift
//  XRouter
//
//  Created by jowsing on 2024/10/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

public protocol RoutableController: Routable, UIViewController {
    
    static var paths: [String] { get }
    
    func update(parameters: Router.Parameters)
    
    func merge(parameters: Router.Parameters)
}

extension RoutableController {
    
    public static func register() {
        paths.forEach { path in
            Router.shared.controllerTypes[path.lowercased()] = Self.self
        }
    }
}
