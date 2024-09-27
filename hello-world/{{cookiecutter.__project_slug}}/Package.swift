// swift-tools-version: {{ cookiecutter._swift_tools_version }}
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "aws-swift-app",
    platforms: [.macOS(.v12)],
    products: [
        .executable(name: "HelloWorld", targets: ["HelloWorld"])
    ],
    dependencies: [
        .package(url: "https://github.com/swift-server/swift-aws-lambda-runtime", from: "{{ cookiecutter._swift_aws_lambda_runtime_version }}"),
    ],
    targets: [
        .executableTarget(
            name: "HelloWorld",
            dependencies: [
                .product(name: "AWSLambdaRuntime",package: "swift-aws-lambda-runtime")
            ]
        )
    ]
)
