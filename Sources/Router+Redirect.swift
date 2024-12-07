//
//  Router+Redirect.swift
//  XRouter
//
//  Created by jowsing on 2024/12/7.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation

extension Router {
    
    public typealias RedirectResultHandler = (Result<[String: Any]?, Error>) -> Void
    
    public typealias RedirectHandler = (@escaping RedirectResultHandler) -> Void
    
    struct Redirection {
        let trigger: ((Router.URL) -> Void)
    }
    
    static func redirect(url: Router.URL) -> Bool {
        guard let redirection = self.shared.redirections[url.path] else { return false }
        redirection.trigger(url)
        return true
    }
    
    public static func setRedirect(from nativePath: String, to url: String, handler: RedirectHandler? = nil) {
        // 不允许重定向到自己
        guard !url.lowercased().contains(nativePath.lowercased()) else {
            return
        }
        let redirect = Redirection { routerUrl in
            guard let handler = handler else {
                self.open(url: url, parameters: routerUrl.parameters.values)
                return
            }
            handler { result in
                switch result {
                case .success(let params):
                    self.open(url: url, parameters: params)
                case .failure:
                    self.openNativePage(routerUrl)
                }
            }
        }
        self.shared.redirections[nativePath.lowercased()] = redirect
    }
}
