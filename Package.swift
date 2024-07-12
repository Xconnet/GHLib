// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "GHLib",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "GHLib",
            targets: ["GHLib"]),
    ],
    dependencies: [
        .package(url: "https://github.com/evgenyneu/keychain-swift.git", .upToNextMajor(from: "24.0.0")),
        .package(url: "https://github.com/elai950/AlertToast.git", .upToNextMajor(from: "1.3.9")),
        .package(url: "https://github.com/duemunk/Async.git", .upToNextMajor(from: "2.1.0")),
        .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", .upToNextMajor(from: "5.0.2")),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", .upToNextMajor(from: "1.8.2")),
        .package(url: "https://github.com/Moya/Moya.git", .upToNextMajor(from: "15.0.3")),
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.9.1")),
        .package(url: "https://github.com/google/GoogleSignIn-iOS.git", .upToNextMajor(from: "7.1.0"))
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
                .product(name: "GoogleSignIn", package: "GoogleSignIn-iOS")
            ],
            path: "Sources/GHLib"
        )
    ]
)
