---
layout: default
---

![Image description](assets/images/banner.png)

The [AWS Serverless Application Model (SAM)](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-specification.html) is an open-source framework for building serverless applications. This page shows you how to use SAM to deploy Server-side Swift applications to AWS. Each application uses [AWS Lambda](https://aws.amazon.com/lambda/) Functions written in Swift. The functions use the [AWS SDK for Swift](https://docs.aws.amazon.com/sdk-for-swift/latest/developer-guide/getting-started.html) and the [Swift AWS Lambda Runtime](https://github.com/swift-server/swift-aws-lambda-runtime).


## Get the Tools

To deploy an application using SAM, you need an AWS account and the following tools on your development machine. While it may work with alternative versions, we recommend you deploy the specified minimum version.

* [AWS Command Line Interface (AWS CLI)](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) (^2.4.19) the AWS CLI is used to configure the AWS credentials on your development machine.
* [AWS SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-sam-cli.html) (^1.82.0)
* [Docker](https://www.docker.com/products/docker-desktop) (^24.0) SAM uses Docker to compile the Swift Lambda functions for Linux distribution to AWS Lambda.


## Create a Project
Once you have the tools installed, from a command prompt on your machine, use the *sam init* command to initialize a new project.

``` bash
sam init --location gh:aws-samples/aws-sam-swift
```

When prompted, specify a name for your project and select the template for the type of project you want to generate. Then switch to the project's folder. 

Application specific instructions to build, deploy, and use the application are located in the **README.md** file of the generated project.

## Project Templates
The tool currently supports two templates. Check back often, as we intend to add new templates regularly.

- **Hello World** creates a basic Lambda function that returns a welcome message. It also creates an [Amazon API Gateway](https://aws.amazon.com/api-gateway/) REST endpoint to invoke your function.

- **Serverless API** creates a full REST API to add, update, select, and remove items in an [Amazon DynamoDB](https://aws.amazon.com/dynamodb/) database. An API Gateway uses Lambda functions to handle each action.

## License

This library is licensed under the MIT-0 License. See the [LICENSE](https://github.com/aws-samples/aws-sam-swift/blob/main/LICENSE) file in the project code repository.

