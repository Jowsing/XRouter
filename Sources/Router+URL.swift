//
//  Router+URL.swift
//  XRouter
//
//  Created by jowsing on 2024/11/6.
//

import Foundation

extension Router {
    
    enum Scheme {
        case web
        case native
        case thirdApp
        
        init(scheme: String) {
            if scheme.isEmpty {
                self = .native
            } else if scheme == "http" || scheme == "https" {
                self = .web
            } else if Router.shared.appSchemes.contains(scheme) {
                self = .native
            } else {
                self = .thirdApp
            }
        }
    }
    
    struct URL {
        let scheme: Scheme
        let host: String
        let path: String
        let parameters: Parameters
        
        let url: Foundation.URL
        
        static func routingURL(_ urlStr: String, parameters: [String: Any]?) -> Router.URL? {
            guard let url = Foundation.URL(string: urlStr.lowercased()) else { return nil }
            var params = parameters ?? [:]
            url.query?.components(separatedBy: "&").forEach({
                let kvarr = $0.components(separatedBy: "=")
                let (key, value) = (kvarr[0], kvarr[1])
                if kvarr.count == 2 && !key.isEmpty && !value.isEmpty {
                    params[key] = value
                }
            })
            return self.init(scheme: Scheme(scheme: url.scheme ?? ""), host: url.host ?? "", path: url.path, parameters: .init(params), url: url)
        }
        
        var action: Action {
            return parameters.routingAction
        }
        
        var browser: Browser {
            return parameters.routingBrowser
        }
    }
    
    public struct Parameters {
        
        private(set) var values: [String: Any]
        
        init(_ dict: [String : Any]) {
            self.values = dict
        }
        
        public subscript(_ key: String) -> Any? {
            get {
                return values[key]
            }
            set(newValue) {
                self.values[key] = newValue
            }
        }
        
        var routingAction: Action {
            var action: Action?
            if let value = values["routingAction"] as? Action {
                action = value
            }
            else if let str = values["routingAction"] as? String {
                action = Action(rawValue: str)
            }
            return action ?? .push
        }
        
        var routingBrowser: Browser {
            var browser: Browser?
            if let value = values["routingBrowser"] as? Browser {
                browser = value
            }
            else if let str = values["routingBrowser"] as? String {
                browser = Browser(rawValue: str)
            }
            return browser ?? .webView
        }
    }
    
    // MARK: - 跳转方式
    public enum Action: String {
        case push
        case singlePush
        case modal
    }
    
    // MARK: - 网页浏览器
    public enum Browser: String {
        case webView
        case safari
        case safariView
    }
}
