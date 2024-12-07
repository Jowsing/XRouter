//
//  Router.swift
//  XRouter
//
//  Created by jowsing on 2024/10/16.
//

import UIKit

public final class Router {
        
    public static let shared = Router()
    
    private var logHandler: ((String) -> Void)?
    
    private(set) var appSchemes: [String] = []
        
    var controllerTypes = [String: RoutableController.Type]()
    
    var serviceTypes = [String: any RoutableService.Type]()
    
    var interceptors = [Interceptor]()
    
    var redirections = [String: Redirection]()
    
    public func launch(with options: [UIApplication.LaunchOptionsKey: Any]?) {
        self.loadConfig { config in
            self.register(config.registrables)
            self.launching(config.launchables, launchOptions: options)
        }
    }
    
    public func addAppScheme(_ appScheme: String) {
        self.appSchemes.append(appScheme)
    }
    
    public func addLogHandler(_ handler: @escaping (String) -> Void) {
        self.logHandler = handler
    }
    
    static func log(_ msg: @autoclosure () -> String) {
        guard let logHandler = Router.shared.logHandler else { return }
        logHandler(msg())
    }
    
    /// 加载各个模块的路由数据
    private func loadConfig(_ resultHandler: @escaping (Config) -> Void) {
        guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
              let buildVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else { return }
        // 路由配置版本：版本号 + build
        let version = appVersion + "_" + buildVersion
        // 先从本地读取
        if Config.load(from: version, resultHandler: resultHandler) {
            return
        }
        // 如果无法获取本地数据，则从运行时中读取
        let classList = Runtime.loadAllClass()
        DispatchQueue.global(qos: .userInteractive).async {
            var registrations = [Registrable.Type]()
            var launchings = [Launchable.Type]()
            classList.forEach { cls in
                if let type = cls as? Launchable.Type {
                    launchings.append(type)
                }
                if let type = cls as? Registrable.Type {
                    registrations.append(type)
                }
            }
            launchings.sort(by: { $0.priority > $1.priority })
            
            let config = Config(registrables: registrations, launchables: launchings)
            
            resultHandler(config)
            
            config.save(with: version)
        }
    }
    
    /// 自动化注册类型表
    private func register(_ registrations: [Registrable.Type]) {
        registrations.forEach {
            $0.register()
        }
    }
    
    /// 自动化开始所有启动插件
    private func launching(_ plugins: [Launchable.Type], launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        plugins.forEach { plugin in
            if let queue = plugin.queue {
                queue.async {
                    plugin.didFinishLaunching(withOptions: launchOptions)
                }
            } else {
                plugin.didFinishLaunching(withOptions: launchOptions)
            }
        }
    }
}
