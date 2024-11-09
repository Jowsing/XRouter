//
//  Router+Jump.swift
//  Pods
//
//  Created by jowsing on 2024/10/17.
//

import UIKit
import SafariServices

extension Router {
        
    // MARK: - Open Page
    
    public static func open(url: String, parameters: [String: Any]? = nil) {
        guard let routingURL = self.getRoutingURL(url, parameters: parameters) else {
            return
        }
        switch routingURL.scheme {
        case .web:
            self.openWebPage(routingURL)
        case .native:
            self.openNativePage(routingURL)
        case .thirdApp:
            UIApplication.shared.open(routingURL.url)
        }
    }
    
    public static func routingViewController(url: String, parameters: [String: Any]? = nil) -> UIViewController? {
        guard let routingURL = self.getRoutingURL(url, parameters: parameters),
                let controllerType = self.getRoutingControllerType(routingURL)
        else {
            return nil
        }
        let vc = controllerType.init()
        vc.update(parameters: routingURL.parameters)
        return vc
    }
    
    private static func getRoutingURL(_ url: String, parameters: [String: Any]? = nil) -> Router.URL? {
        guard let routingURL = Router.URL.routingURL(url, parameters: parameters) else {
            self.log("请使用正确的router URL")
            return nil
        }
        return routingURL
    }
    
    private static func getRoutingControllerType(_ routingURL: Router.URL) -> RoutableController.Type? {
        guard routingURL.scheme == .native else {
            self.log("请使用正确的scheme，或者配置好对应的scheme")
            return nil
        }
        if Router.shared.intercept(routingURL.path, parameters: routingURL.parameters) {
            self.log("路由被拦截，url = \(routingURL.url.absoluteString)")
            return nil
        }
        guard let controllerType = Router.shared.controllerTypes[routingURL.path] else {
            self.log("无法找到\(routingURL.url.absoluteString)对应的controllerType，请实现RoutableController协议")
            return nil
        }
        return controllerType
    }
    
    private static func openNativePage(_ routingURL: Router.URL) {
        guard let controllerType = self.getRoutingControllerType(routingURL) else { return }
        self.jumpToNative(type: controllerType, action: routingURL.action, parameters: routingURL.parameters)
    }
    
    private static func openWebPage(_ routingURL: Router.URL) {
        switch routingURL.browser {
        case .webView:
            self.jumpToWebView(routingURL: routingURL)
        case .safari:
            UIApplication.shared.open(routingURL.url)
        case .safariView:
            self.jumpToSafariView(url: routingURL.url)
        }
    }
    
    private static func jumpToNative(type: RoutableController.Type, action: Action, parameters: Parameters) {
        switch action {
        case .push:
            let vc = type.init()
            vc.update(parameters: parameters)
            self.currentNavigationController()?.pushViewController(vc, animated: true)
        case .modal:
            let vc = type.init()
            vc.update(parameters: parameters)
            self.currentViewController(self.keyWindow?.rootViewController)?.present(vc, animated: true)
        case .singlePush:
            guard let navigationController = self.currentNavigationController() else { return }
            if let vc = navigationController.viewControllers.first(where: { $0.isKind(of: type) }) {
                (vc as? RoutableController)?.merge(parameters: parameters)
                navigationController.popToViewController(vc, animated: true)
            } else {
                let vc = type.init()
                vc.update(parameters: parameters)
                navigationController.pushViewController(vc, animated: true)
            }
        }
    }
    
    private static func jumpToWebView(routingURL: Router.URL) {
        var parameters = routingURL.parameters.values
        parameters["url"] = routingURL.url
        guard let webRoutingURL = self.getRoutingURL("/webView", parameters: parameters) else { return }
        guard let controllerType = self.getRoutingControllerType(webRoutingURL) else { return }
        self.jumpToNative(type: controllerType, action: routingURL.action, parameters: webRoutingURL.parameters)
    }
    
    private static func jumpToSafariView(url: Foundation.URL) {
        let vc: SFSafariViewController
        if #available(iOS 11.0, *) {
            let configuration = SFSafariViewController.Configuration()
            configuration.entersReaderIfAvailable = true
            vc = SFSafariViewController(url: url, configuration: configuration)
            vc.dismissButtonStyle = .close
        } else {
            vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
        }
        self.currentViewController(keyWindow?.rootViewController)?.present(vc, animated: true)
    }
    
    // MARK: - Go Back
    
    public static func back(_ url: String, parameters: [String: Any]? = nil) {
        guard let routingURL = Router.URL.routingURL(url, parameters: parameters) else {
            self.log("请使用正确的router URL")
            return
        }
        if Router.shared.intercept(routingURL.path, parameters: routingURL.parameters) {
            self.log("back被拦截，url = \(routingURL.url.absoluteString)")
            return
        }
        guard let controllerType = Router.shared.controllerTypes[routingURL.path] else {
            self.log("无法找到\(routingURL.url.absoluteString)对应的controllerType")
            return
        }
        self.back(type: controllerType, parameters: routingURL.parameters)
    }
    
    static func back(type: UIViewController.Type, parameters: Parameters) {
        guard let currentVC = self.currentViewController(keyWindow?.rootViewController), !currentVC.isKind(of: type) else {
            return
        }
        // 如果当前控制器是被modal出来的，那么先dismiss，再去找要返回的目标
        if currentVC.presentingViewController != nil {
            currentVC.dismiss(animated: false) {
                self.back(type: type, parameters: parameters)
            }
            return
        }
        // 如果在导航之中
        // 且栈顶不是当前控制器
        // 先找目标控制器在不在这个导航里
        guard let navVC = currentVC.navigationController, let topVC = navVC.topViewController, !topVC.isKind(of: type) else { return }
        guard let targetVC = navVC.viewControllers.last(where: { $0.isKind(of: type) }) else {
            // 在导航中找TabBarController的选中控制器
            if let tabBarVC = navVC.viewControllers.last(where: { $0.isKind(of: UITabBarController.self) }) as? UITabBarController, let selectedVC = tabBarVC.selectedViewController, selectedVC.isKind(of: type) {
                if let paramsVC = selectedVC as? RoutableController {
                    paramsVC.merge(parameters: parameters)
                }
                navVC.popToViewController(tabBarVC, animated: true)
            }
            // 如果导航控制器也是modal出来的，则继续往上找
            if navVC.presentingViewController != nil {
                navVC.dismiss(animated: false) {
                    self.back(type: type, parameters: parameters)
                }
            }
            return
        }
        if let paramsVC = targetVC as? RoutableController {
            paramsVC.merge(parameters: parameters)
        }
        navVC.popToViewController(targetVC, animated: true)
    }
    
    // MARK: - UIKit
    
    @available(iOS 13.0, *)
    static var windowScene: UIWindowScene? {
        return UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }).filter({$0.activationState == .foregroundActive}).first
    }
    
    static var keyWindow: UIWindow? {
        if let delegate = UIApplication.shared.delegate, let window = delegate.window {
            return window
        }
        if #available(iOS 13.0, *) {
            return windowScene?.windows.first(where: \.isKeyWindow)
        }
        return nil
    }
    
    static func currentNavigationController() -> UINavigationController? {
        if let root = self.keyWindow?.rootViewController as? UINavigationController {
            return self.lastNavigationController(root)
        }
        if let root = self.keyWindow?.rootViewController as? UITabBarController {
            if let navc = root.selectedViewController as? UINavigationController {
                return self.lastNavigationController(navc)
            }
        }
        if let navc = self.keyWindow?.rootViewController?.presentedViewController as? UINavigationController {
            return self.lastNavigationController(navc)
        }
        return nil
    }
    
    static func lastNavigationController(_ from: UINavigationController) -> UINavigationController? {
        if let navc = from.presentedViewController as? UINavigationController {
            return self.lastNavigationController(navc)
        }
        if let navc = from.topViewController?.presentedViewController as? UINavigationController {
            return self.lastNavigationController(navc)
        }
        return from
    }

    static func currentViewController(_ from: UIViewController?) -> UIViewController? {
        var vc = from
        if let presentedVC = from?.presentedViewController {
            vc = presentedVC
        }
        if let tabBarVC = vc as? UITabBarController {
            return self.currentViewController(tabBarVC.selectedViewController)
        }
        if let navVC = vc as? UINavigationController {
            return self.currentViewController(navVC.visibleViewController)
        }
        return vc
    }
}
