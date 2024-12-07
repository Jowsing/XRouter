# XRouter

[![SPM](https://img.shields.io/badge/SPM-supported-DE5C43.svg?style=flat)](https://swift.org/package-manager/)
[![Version](https://img.shields.io/cocoapods/v/X-Router.svg?style=flat)](https://cocoapods.org/pods/X-Router)
[![License](https://img.shields.io/cocoapods/l/X-Router.svg?style=flat)](https://cocoapods.org/pods/X-Router)
[![Platform](https://img.shields.io/cocoapods/p/X-Router.svg?style=flat)](https://cocoapods.org/pods/X-Router)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

#### Swift Package Manager

- File > Swift Packages > Add Package Dependency
- Add `https://github.com/Jowsing/XRouter`
- Select "Up to Next Major" with "1.0.2"

### Cocoapods

XRouter is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'X-Router'
```

## Usage

### Initial

```swift
// Override point for customization after application launch.
Router.shared.launch(with: launchOptions)
// My custom app scheme
Router.shared.addAppScheme("demo")
// Log
Router.shared.addLogHandler { msg in
    print("Router Log ->", msg)
}
```

### Register

```swift
/// Native Page
extension DemoViewController: RoutableController {

    static var paths: [String] {
        ["/demo"]
    }
    /// Replace the old parameters
    func update(parameters: Router.Parameters) {
        print("parameters ->", parameters)
        self.circleLayer.fillColor = (parameters["color"] as? UIColor)?.cgColor
    }

    /// Merge with the old parameters
    func merge(parameters: Router.Parameters) {

    }

}

/// Web Page
extension WebViewController: RoutableWebController {

    func update(parameters: Router.Parameters) {
        guard let url = parameters["url"] as? URL else { return }
        self.webView.load(.init(url: url))
        self.getHTMLData(url.absoluteString)
    }
}
```

### Module Launchable Settings

```swift
extension HomeViewController: Launchable {

    static var queue: DispatchQueue? {
        .main
    }

    static var priority: UInt {
        .max
    }

    static func didFinishLaunching(withOptions: [UIApplication.LaunchOptionsKey : Any]?) {
	// First Page
        Router.open(url: "/home")

	// Add the interceptors
        let whiteList = ["/login"]
        Router.addInterceptor(whiteList, priority: .max) { params in
            if accessToken.isEmpty {
                Router.open(url: "/login")
                return true
            }
            return false
        }

        // Just Redirect
        Router.setRedirect(from: "/Redirect1", to: "/mine")

        // Redirect with trigger
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
```

### Open URL

```swift
// just open
Router.open(url: "/demo", parameters: ["color": UIColor.red])

@objc func openLink() {
    textField?.resignFirstResponder()
    guard let url = self.textField?.text else { return }
    Router.open(url: url, parameters: ["routingBrowser": self.routingBrowser])
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
```

## Author

jowsing, jowsing169@gmail.com

## License

XRouter is available under the MIT license. See the LICENSE file for more info.
