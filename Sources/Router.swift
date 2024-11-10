//
//  Router.swift
//  XRouter
//
//  Created by jowsing on 2024/10/16.
//

import UIKit

let xModulesFileName = "XRouter_modules_file"
let xModulesVersion = "XRouter_modules_version"
let xDocumentsPath = NSHomeDirectory() + "/Documents/"

public final class Router {
        
    public static let shared = Router()
    
    private var logHandler: ((String) -> Void)?
    
    private(set) var appSchemes: [String] = []
        
    var controllerTypes = [String: RoutableController.Type]()
    
    var serviceTypes = [String: any RoutableService.Type]()
    
    var interceptors = [Interceptor]()
    
    public func launch(with options: [UIApplication.LaunchOptionsKey: Any]?) {
        self.loadModules { modules in
            self.register(modules.registrables)
            self.launching(modules.launchables, launchOptions: options)
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
    private func loadModules(_ resultHandler: @escaping (Modules) -> Void) {
        guard let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return }
        // 先从本地缓存中取
        #if DEBUG
        #else
        if self.loadFromDisk(currentVersion, resultHandler: resultHandler) {
            return
        }
        #endif
        // 如果从缓存中无法获取，则从app的包中筛取
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
            let modules = Modules(registrables: registrations, launchables: launchings)
            resultHandler(modules)
            
            // 写入本地缓存
            #if DEBUG
            #else
            let fileURL = Foundation.URL(fileURLWithPath: xDocumentsPath + xModulesFileName)
            if modules.write(to: fileURL) {
                // 写入成功则更新版本
                UserDefaults.standard.set(currentVersion, forKey: xModulesVersion)
            }
            #endif
        }
    }
    
    /// 从本地数据读取
    /// 如果本地缓存的version存在，且与项目的版本一致，则从尝试从本地缓存取出
    private func loadFromDisk(_ currentVersion: String, resultHandler: @escaping (Modules) -> Void) -> Bool {
        guard let moudleVersion = UserDefaults.standard.string(forKey: xModulesVersion), moudleVersion == currentVersion else { return false }
        DispatchQueue.global(qos: .userInteractive).async {
            let fileURL = Foundation.URL(fileURLWithPath: NSHomeDirectory() + "/Documents/" + xModulesFileName)
            guard let data = try? Data(contentsOf: fileURL) else { return }
            guard let model = try? JSONDecoder().decode(Modules.self, from: data) else { return }
            resultHandler(model)
        }
        return true
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

extension Router {
    
    struct Modules: Codable {
        
        let registrables: [Registrable.Type]
        
        let launchables: [Launchable.Type]
        
        enum CodingKeys: String, CodingKey {
            case registrables, launchables
        }
        
        init(registrables: [Registrable.Type] = [], launchables: [Launchable.Type] = []) {
            self.registrables = registrables
            self.launchables = launchables
        }
        
        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let registrables = try container.decode([String].self, forKey: .registrables)
            let launchables = try container.decode([String].self, forKey: .launchables)
            self.registrables = registrables.compactMap({ NSClassFromString($0) as? Registrable.Type })
            self.launchables = launchables.compactMap({ NSClassFromString($0) as? Launchable.Type })
        }
        
        func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(self.registrables.map({ NSStringFromClass($0) }), forKey: .registrables)
            try container.encode(self.launchables.map({ NSStringFromClass($0) }), forKey: .launchables)
        }
        
        func write(to url: Foundation.URL) -> Bool {
            do {
                let data = try JSONEncoder().encode(self)
                try data.write(to: url, options: .atomic)
                return true
            } catch _ {
                return false
            }
        }
    }
}
