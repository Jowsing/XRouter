//
//  Launchable.swift
//  XRouter
//
//  Created by jowsing on 2024/10/16.
//

import UIKit

public protocol Launchable: NSObject {
    
    static var queue: DispatchQueue? { get }
    
    static var priority: UInt { get }
    
    static func didFinishLaunching(withOptions: [UIApplication.LaunchOptionsKey: Any]?)
}

extension Launchable {
    
    static var queue: DispatchQueue? {
        return nil
    }
    
    static var priority: UInt {
        return 0
    }
}
