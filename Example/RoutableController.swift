//
//  RoutableViewController.swift
//  XRouter
//
//  Created by jowsing on 2024/10/17.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

public protocol RoutableController: Routable, UIViewController {
    
    func updateParam(_ param: Any?)
}
