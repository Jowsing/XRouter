//
//  Config.swift
//  X-Router
//
//  Created by jowsing on 2024/12/6.
//

import Foundation

extension Router {
    
    struct Config: Codable {
        
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



extension Router.Config {
    
    static let webviewPath = "/XRouter_WebView_Path"
    
    static let versionKey = "XRouter_version_key"
    
    static var version: String {
        get {
            UserDefaults.standard.string(forKey: self.versionKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: self.versionKey)
        }
    }
            
    static let filePath = {
        return NSHomeDirectory() + "/Documents/XRouter_Config_File"
    }()
    
    /// 从本地读取路由配置
    /// version: 需要读取的版本
    /// return: 读取成功与否
    static func load(from version: String, resultHandler: @escaping (Router.Config) -> Void) -> Bool {
#if DEBUG
        return false
#else
        guard self.version == version else { return false }
        DispatchQueue.global(qos: .userInteractive).async {
            let fileURL = Foundation.URL(fileURLWithPath: self.filePath)
            guard let data = try? Data(contentsOf: fileURL) else { return }
            guard let config = try? JSONDecoder().decode(Self.self, from: data) else { return }
            resultHandler(config)
        }
        return true
#endif
    }
    
    func save(with version: String) {
#if DEBUG
        
#else
        let fileURL = Foundation.URL(fileURLWithPath: Self.filePath)
        if self.write(to: fileURL) {
            // 写入成功则更新版本
            Self.version = version
        }
#endif
    }
}
