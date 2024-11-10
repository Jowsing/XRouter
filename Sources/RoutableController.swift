//
//  RoutableViewController.swift
//  XRouter
//
//  Created by jowsing on 2024/10/17.
//

import UIKit

public protocol RoutableController: Registrable, UIViewController {
    
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
