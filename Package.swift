// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "XRouter",
    platforms: [.iOS(.v10)],
    products: [
        .library(name: "XRouter", targets: ["XRouter"])
    ],
    targets: [
        .target(
            name: "XRouter",
            path: "Sources"
        )
    ]
)
