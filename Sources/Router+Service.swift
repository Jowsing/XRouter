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
    
    public static func sharedService(with name: String) -> RoutableService? {
        return Router.shared.sharedServices[name]
    }
    
    @discardableResult
    public static func addSharedService(with name: String) -> RoutableService? {
        if let service = self.sharedService(with: name) {
            return service
        }
        guard let serviceType = self.getServiceType(with: name) else { return nil }
        let service = serviceType.init()
        Router.shared.sharedServices[name] = service
        return service
    }
    
    @discardableResult
    public static func removeSharedService(with name: String) -> RoutableService? {
        return Router.shared.sharedServices.removeValue(forKey: name)
    }
}
