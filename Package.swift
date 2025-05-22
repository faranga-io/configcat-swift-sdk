// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "ConfigCat",
    platforms: [
        .iOS(.v12),
        .watchOS(.v4),
        .tvOS(.v12),
        .macOS(.v10_15)
    ],
    products: [
        .library(name: "ConfigCat", targets: ["ConfigCat"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-crypto.git", from: "3.0.0")
    ],
    targets: [
        .target(name: "Version",
                exclude: ["LICENSE" , "version.txt"]),
        .target(name: "ConfigCat",
                dependencies: ["Version",
                               .product(name: "Crypto", package: "swift-crypto")],
                exclude: ["Resources/ConfigCat.h", "Resources/Info.plist"],
                resources: [.copy("Resources/PrivacyInfo.xcprivacy")],
                swiftSettings: [
                    .define("DEBUG", .when(configuration: .debug))
                ]),
        .testTarget(name: "ConfigCatTests",
                    dependencies: ["ConfigCat"],
                    exclude: ["Resources/Info.plist"],
                    resources: [.process("Resources")]
        )
        
    ],
    swiftLanguageVersions: [.v5]
)
