//
//  RoutableWebController.swift
//  XRouter
//
//  Created by jowsing on 2024/11/7.
//

import Foundation

public protocol RoutableWebController: RoutableController {}

extension RoutableWebController {
    
    public static var paths: [String] {
        [Router.Config.webviewPath]
    }
}
