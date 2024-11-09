//
//  Router+Handler.swift
//  Pods
//
//  Created by jowsing on 2024/10/17.
//

import Foundation

extension Router {
    
    public static func getServiceType(with name: String) -> RoutableService.Type? {
        return Router.shared.serviceTypes[name]
    }
}
