//
//  Runtime.swift
//  XRouter
//
//  Created by jowsing on 2024/10/17.
//

import Foundation

/// 苹果系统类
let xAppleSuffix = "com.apple"
/// cocoaPods相关库
let xCocoaPodsSuffix = "org.cocoapods"

public struct Runtime {
    
    /// 获取包内的所有类
    public static func loadClass(in bundle: CFBundle) -> [AnyClass] {
        var result = [AnyClass]()
        if let executableURL = CFBundleCopyExecutableURL(bundle) {
            let imageURL = (executableURL as NSURL).fileSystemRepresentation
            let classCount = UnsafeMutablePointer<UInt32>.allocate(capacity: MemoryLayout<UInt32>.stride)
            if let classNames = objc_copyClassNamesForImage(imageURL, classCount) {
                for i in 0..<Int(classCount.pointee) {
                    let name = String(cString: classNames[i])
                    guard let cls = NSClassFromString(name) else { continue }
                    result.append(cls)
                }
            }
        }
        return result
    }
    
    
    /// 获取项目中的所有类
    /// 过滤系统类和 Pods 中的无关类的包
    /// 私有的Pods Module 请修改 bundle id, 避免含有 org.cocoapods
    public static func loadAllClass() -> [AnyClass] {
        var result = [AnyClass]()
        if let bundles = CFBundleGetAllBundles() as? [CFBundle] {
            for bundle in bundles {
                guard let id = CFBundleGetIdentifier(bundle) as? String else { continue }
                /// 如果是apple的系统库，过滤
                if id.hasPrefix(xAppleSuffix) {
                    continue
                }
                /// 如果是Pods库，过滤
                if id.hasPrefix(xCocoaPodsSuffix) {
                    continue
                }
                result.append(contentsOf: self.loadClass(in: bundle))
            }
        }
        return result
    }
}
