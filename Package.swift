// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "X-Router",
    platforms: [.iOS(.v10)],
    products: [
        .library(name: "X-Router", targets: ["X-Router"])
    ],
    targets: [
        .target(
            name: "X-Router",
            path: "Sources"
        )
    ]
)
