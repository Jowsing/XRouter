//
//  ViewController.swift
//  XRouter
//
//  Created by jowsing on 10/16/2024.
//  Copyright (c) 2024 jowsing. All rights reserved.
//

import UIKit
import X_Router

class DemoViewController: UIViewController {
    
    let circleLayer = CAShapeLayer()
    
    private var textField: UITextField?
    
    private var routingBrowser = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.title = "Demo"
        self.circleLayer.frame = CGRect(x: view.bounds.width * 0.5 - 40, y: UIApplication.shared.statusBarFrame.height + 108, width: 80, height: 80)
        self.circleLayer.path = UIBezierPath(roundedRect: circleLayer.bounds, cornerRadius: circleLayer.bounds.width * 0.5).cgPath
        self.view.layer.addSublayer(circleLayer)
        self.view.backgroundColor = .white
        
        let textField = UITextField(frame: CGRect(x: 30, y: circleLayer.frame.maxY + 80, width: view.bounds.width - 60, height: 50))
        textField.placeholder = "请输入网址"
        textField.textAlignment = .center
        textField.textColor = .black
        textField.font = .systemFont(ofSize: 20)
        self.view.addSubview(textField)
        textField.addTarget(self, action: #selector(textDidChange(sender:)), for: .editingChanged)
        self.textField = textField
        
        let btn0 = UIButton(frame: CGRect(x: 50, y: textField.frame.maxY + 10, width: view.bounds.width - 100, height: 30))
        btn0.setTitle("请选择浏览器", for: .normal)
        btn0.setTitleColor(.systemBlue, for: .normal)
        btn0.titleLabel?.font = .systemFont(ofSize: 17)
        view.addSubview(btn0)
        btn0.addTarget(self, action: #selector(browserType(sender:)), for: .touchUpInside)
        
        let btn1 = UIButton(frame: CGRect(x: 50, y: btn0.frame.maxY + 20, width: view.bounds.width - 100, height: 40))
        btn1.setTitle("Go", for: .normal)
        btn1.setTitleColor(.systemBlue, for: .normal)
        btn1.titleLabel?.font = .systemFont(ofSize: 25, weight: .medium)
        view.addSubview(btn1)
        btn1.addTarget(self, action: #selector(openLink), for: .touchUpInside)
    }
    
    @objc func textDidChange(sender: UITextField) {
        
    }
    
    @objc func browserType(sender: UIButton) {
        let alert = UIAlertController(title: "选择浏览器", message: nil, preferredStyle: .actionSheet)
        alert.addAction(.init(title: "默认(WebView)", style: .default, handler: { [weak self] _ in
            self?.routingBrowser = ""
            sender.setTitle("请选择浏览器", for: .normal)
        }))
        alert.addAction(.init(title: "WebView", style: .default, handler: { [weak self] _ in
            self?.routingBrowser = "webView"
            sender.setTitle("WebView", for: .normal)
        }))
        alert.addAction(.init(title: "SafariView", style: .default, handler: { [weak self] _ in
            self?.routingBrowser = "safariView"
            sender.setTitle("SafariView", for: .normal)
        }))
        alert.addAction(.init(title: "Safari", style: .default, handler: { [weak self] _ in
            self?.routingBrowser = "safari"
            sender.setTitle("Safari", for: .normal)
        }))
        alert.addAction(.init(title: "取消", style: .cancel))
        self.present(alert, animated: true)
    }
    
    @objc func openLink() {
        textField?.resignFirstResponder()
        guard let url = self.textField?.text else { return }
        Router.open(url: url, parameters: ["routingBrowser": self.routingBrowser])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField?.resignFirstResponder()
    }

}

extension DemoViewController: RoutableController {
    func merge(parameters: Router.Parameters) {
        
    }
    
    static var paths: [String] {
        ["/demo"]
    }
    
    func update(parameters: Router.Parameters) {
        print("parameters ->", parameters)
        self.circleLayer.fillColor = (parameters["color"] as? UIColor)?.cgColor
    }
    
}

