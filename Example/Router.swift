//
//  Router.swift
//  XRouter
//
//  Created by jowsing on 2024/10/16.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

public final class Router {
    
    static let shared = Router()
    
    /// RoutableController
    var controllerTypes = [String: RoutableController.Type]()
    /// RoutableHandler
    var handlerTypes = [String: RoutableHandler.Type]()
    /// Interceptor
    var interceptors = [Interceptor]()
    
    func add(interceptor: Interceptor) {
        var insertIndex: Int?
        for i in 0..<interceptors.count {
            if interceptors[i].priority < interceptor.priority {
                insertIndex = i
                break
            }
        }
        if let index = insertIndex {
            interceptors.insert(interceptor, at: index)
        } else {
            interceptors.append(interceptor)
        }
    }
    
    func setService(_ service: RouterService.Type, forName: String) {
        if let type = service as? RouterCallbackService.Type {
            serviceInstances[forName] = type.init()
        } else {
            serviceMap[forName] = service
        }
    }
    
    static func nativeType(_ path: String) -> Routable.Type? {
        return shared.nativeRoutesMap[path]
    }
    
    static func nativeExist(_ path: String) -> Bool {
        return nativeType(path) != nil
    }
        
    static func viewController(_ request: Request) -> UIViewController? {
        guard request.scheme == .native else { return nil }
        return nativeType(request.path)?.routeInstance(userInfo: request.params, completion: { _ in
            
        }) as? UIViewController
    }
    
    static func viewController(_ urlString: String, userInfo: [String: Any]? = nil) -> UIViewController? {
        guard let request = urlRequest(urlString, userInfo: userInfo) else { return nil }
        return viewController(request)
    }
    
    static func canOpen(_ urlString: String, userInfo: [String: Any]? = nil) -> Bool {
        guard let request = urlRequest(urlString, userInfo: userInfo) else { return false }
        if request.scheme == .native {
            return nativeExist(request.path)
        }
        return true
    }
}
