// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SteppedViewController",
    platforms: [ .iOS(.v11)],
    products: [
        .library(
            name: "SteppedViewController",
            targets: ["SteppedViewController"]),
    ],
    dependencies: [
        .package(url: "https://github.com/amratab/FlexibleSteppedProgressBar.git", .upToNextMinor(from: "0.6.3")),
        .package(url: "https://github.com/prashantLalShrestha/CocoaUI.git", .upToNextMinor(from: "1.6.0")),
    ],
    targets: [
        .target(
            name: "SteppedViewController",
            dependencies: ["FlexibleSteppedProgressBar", "CocoaUI"],
            path: "Sources"),
        .testTarget(
            name: "SteppedViewControllerTests",
            dependencies: ["SteppedViewController"],
            path: "SteppedViewControllerTests"),
    ]
)
