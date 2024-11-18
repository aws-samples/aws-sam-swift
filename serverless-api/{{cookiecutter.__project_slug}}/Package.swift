// swift-tools-version: {{ cookiecutter._swift_tools_version }}
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "aws-swift-app",
    platforms: [{{ cookiecutter._mac_os_version }}],
    products: [
        .executable(name: "CreateItem", targets: ["CreateItem"]),
        .executable(name: "GetItems", targets: ["GetItems"]),
        .executable(name: "GetItem", targets: ["GetItem"]),
        .executable(name: "UpdateItem", targets: ["UpdateItem"]),
        .executable(name: "DeleteItem", targets: ["DeleteItem"])
    ],
    dependencies: [
        .package(url: "https://github.com/swift-server/swift-aws-lambda-runtime", branch: "main"),
        .package(url: "https://github.com/swift-server/swift-aws-lambda-events", branch: "main"),
        .package(url: "https://github.com/awslabs/aws-sdk-swift", from: "{{ cookiecutter._aws_swift_sdk_version }}")
    ],
    targets: [
        .executableTarget(
            name: "CreateItem",
            dependencies: [
                .product(name: "AWSLambdaRuntime",package: "swift-aws-lambda-runtime"),
                .product(name: "AWSLambdaEvents", package: "swift-aws-lambda-events"),
                .product(name: "AWSDynamoDB", package: "aws-sdk-swift")
            ]
        ),
        .executableTarget(
            name: "GetItems",
            dependencies: [
                .product(name: "AWSLambdaRuntime",package: "swift-aws-lambda-runtime"),
                .product(name: "AWSLambdaEvents", package: "swift-aws-lambda-events"),
                .product(name: "AWSDynamoDB", package: "aws-sdk-swift")
            ]
        ),
        .executableTarget(
            name: "GetItem",
            dependencies: [
                .product(name: "AWSLambdaRuntime",package: "swift-aws-lambda-runtime"),
                .product(name: "AWSLambdaEvents", package: "swift-aws-lambda-events"),
                .product(name: "AWSDynamoDB", package: "aws-sdk-swift")
            ]
        ),
        .executableTarget(
            name: "UpdateItem",
            dependencies: [
                .product(name: "AWSLambdaRuntime",package: "swift-aws-lambda-runtime"),
                .product(name: "AWSLambdaEvents", package: "swift-aws-lambda-events"),
                .product(name: "AWSDynamoDB", package: "aws-sdk-swift")
            ]
        ),
        .executableTarget(
            name: "DeleteItem",
            dependencies: [
                .product(name: "AWSLambdaRuntime",package: "swift-aws-lambda-runtime"),
                .product(name: "AWSLambdaEvents", package: "swift-aws-lambda-events"),
                .product(name: "AWSDynamoDB", package: "aws-sdk-swift")
            ]
        )
    ]
)
