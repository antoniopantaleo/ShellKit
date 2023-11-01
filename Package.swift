// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "ShellKit",
    platforms: [.macOS(.v12)],
    products: [
        .library(
            name: "ShellKit",
            targets: ["ShellKit"]
        ),
    ],
    targets: [
        .target(name: "ShellKit"),
        .testTarget(
            name: "ZshShellTests",
            dependencies: ["ShellKit"]
        )
    ]
)
