//
//  Router+Interceptor.swift
//  Pods
//
//  Created by jowsing on 2024/10/17.
//

import Foundation

extension Router {
    
    struct Interceptor {
        typealias Handler = (Router.Parameters) -> Bool // 返回true为需要对跳转进行拦截
        
        let whiteList: [String]
        let priority: UInt
        let handler: Handler
        
        init(_ whiteList: [String], priority: UInt, handler: @escaping Handler) {
            self.whiteList = whiteList
            self.priority = priority
            self.handler = handler
        }
        
        /// 是否在白名单中
        func inWhitelist(_ path: String) -> Bool {
            return whiteList.contains(path)
        }
    }
    
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
    
    /// 添加拦截器
    /// - Parameters:
    ///   - whiteList: 白名单
    ///   - priority: 优先级
    ///   - handler: 拦截回调
    public static func addInterceptor(_ whiteList: [String] = [], priority: UInt = 0, handler: @escaping (Parameters) -> Bool) {
        Runtime.onMainThread {
            Router.shared.add(interceptor: Interceptor(whiteList, priority: priority, handler: handler))
        }
    }
    
    /// 是否拦截
    /// - Parameters:
    ///   - path: 跳转的路径
    ///   - userInfo: 跳转的参数
    /// - Returns: 是否拦截该跳转
    func intercept(_ path: String, parameters: Parameters) -> Bool {
        for interceptor in interceptors where !interceptor.inWhitelist(path) {
            if interceptor.handler(parameters) {
                return true
            }
        }
        return false
    }
}
