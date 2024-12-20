//
//  HomeViewController.swift
//  XRouter_Example
//
//  Created by jowsing on 2024/11/7.
//

import UIKit
import X_Router

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Home"
        
        self.view.backgroundColor = .white
        
        let btn1 = UIButton(frame: CGRect(x: 50, y: UIApplication.shared.statusBarFrame.height + 188, width: view.bounds.width - 100, height: 30))
        btn1.setTitle("Jump Demo (Path)", for: .normal)
        btn1.setTitleColor(.systemBlue, for: .normal)
        view.addSubview(btn1)
        btn1.addTarget(self, action: #selector(clickPath), for: .touchUpInside)
        
        let btn2 = UIButton(frame: CGRect(x: 50, y: btn1.frame.maxY + 20, width: view.bounds.width - 100, height: 30))
        btn2.setTitle("Jump Demo (URL)", for: .normal)
        btn2.setTitleColor(.systemBlue, for: .normal)
        view.addSubview(btn2)
        btn2.addTarget(self, action: #selector(clickURL), for: .touchUpInside)
        
        let btn3 = UIButton(frame: CGRect(x: 50, y: btn2.frame.maxY + 20, width: view.bounds.width - 100, height: 30))
        btn3.setTitle("Service Demo", for: .normal)
        btn3.setTitleColor(.systemBlue, for: .normal)
        view.addSubview(btn3)
        btn3.addTarget(self, action: #selector(servicePath), for: .touchUpInside)
    }
    
    @objc private func clickPath() {
        Router.open(url: "/demo", parameters: ["color": UIColor.systemPink])
    }

    @objc private func clickURL() {
        Router.open(url: "demo://./demo", parameters: ["color": UIColor.systemOrange])
    }
    
    @objc private func servicePath() {
        Router.open(url: "/mine")
    }
    
}

extension HomeViewController: RoutableController {
    
    func merge(parameters: Router.Parameters) {
        
    }
    
    static var paths: [String] {
        ["/home"]
    }
    
    func update(parameters: Router.Parameters) {
        
    }
}

extension HomeViewController: Launchable {
    
    static var queue: DispatchQueue? {
        .main
    }
    
    static var priority: UInt {
        .max
    }
    
    static func didFinishLaunching(withOptions: [UIApplication.LaunchOptionsKey : Any]?) {
        Router.open(url: "/home")
        // 直接重定向
        Router.setRedirect(from: "/Redirect1", to: "/mine")
        // 重定向带触发器
        Router.setRedirect(from: "/Redirect2", to: "/demo") { resultHandler in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                if Bool.random() {
                    resultHandler(.success(["color": UIColor.cyan]))
                } else {
                    resultHandler(.failure(NSError(domain: "0", code: 444)))
                }
            }
        }
    }
}
