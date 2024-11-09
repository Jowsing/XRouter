//
//  RoutableHandler.swift
//  XRouter
//
//  Created by jowsing on 2024/10/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation

public protocol RoutableHandler: NSObject, Routable {
    
    static func onHandler(_ param: Any?) -> Void
}
