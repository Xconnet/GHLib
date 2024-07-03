// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GHLib",
    platforms: [.iOS(.v16)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "GHLib",
            targets: ["GHLib"]),
    ],
    dependencies: [
        .package(url: "https://github.com/evgenyneu/keychain-swift.git", from: "24.0.0"),
        .package(url: "https://github.com/elai950/AlertToast.git", from: "1.3.9"),
        .package(url: "https://github.com/duemunk/Async.git", from: "2.1.0"),
        .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", from: "5.0.2"),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", from: "1.8.2"),
        .package(url: "https://github.com/Moya/Moya.git", from: "15.0.3"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.9.1")
    ],
    targets: [
        .target(
            name: "GHLib",
            dependencies: [
                .product(name: "KeychainSwift", package: "keychain-swift"),
                .product(name: "AlertToast", package: "AlertToast"),
                .product(name: "Async", package: "Async"),
                .product(name: "SwiftyJSON", package: "SwiftyJSON"),
                .product(name: "CryptoSwift", package: "CryptoSwift"),
                .product(name: "Moya", package: "Moya"),
                .product(name: "Alamofire", package: "Alamofire"),
            ]),
    ]
)
