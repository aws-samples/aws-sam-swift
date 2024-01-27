---
layout: default
---

![Image description](assets/images/banner.png)

The [AWS Serverless Application Model (SAM)](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-specification.html){:target="_blank"} is an open-source framework for building serverless applications. This page shows you how to use SAM to deploy Server-side Swift applications to AWS. Each application uses [AWS Lambda](https://aws.amazon.com/lambda/){:target="_blank"} Functions written in Swift. The functions use the [AWS SDK for Swift](https://docs.aws.amazon.com/sdk-for-swift/latest/developer-guide/getting-started.html){:target="_blank"} and the [Swift AWS Lambda Runtime](https://github.com/swift-server/swift-aws-lambda-runtime){:target="_blank"}.


## Get the Tools

To deploy an application using SAM, you need an AWS account and the following tools on your development machine. While it may work with alternative versions, we recommend you deploy the specified minimum version.

* [AWS Command Line Interface (AWS CLI)](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html){:target="_blank"} (^2.4.19) the AWS CLI is used to configure the AWS credentials on your development machine.
* [AWS SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-sam-cli.html){:target="_blank"} (^1.103.0)
* [Docker](https://www.docker.com/products/docker-desktop){:target="_blank"} (^24.0) SAM uses Docker to compile the Swift Lambda functions for Linux distribution to AWS Lambda.

**Note**: *make sure you upgrade to **SAM CLI** version **1.103.0** or later. These templates will only work with that version of SAM or greater.*

## Create a Project
Once you have the tools installed, from a command prompt on your machine, use the *sam init* command to initialize a new project.

``` bash
sam init --location gh:aws-samples/aws-sam-swift
```

When prompted, specify a name for your project and select the template for the type of project you want to generate. Then switch to the project's folder. 

Application specific instructions to build, deploy, and use the application are located in the **README.md** file of the generated project.

## Project Templates
The tool supports these templates.

- **Hello World** creates a basic Lambda function written in Swift that returns a welcome message. It also creates an [Amazon API Gateway](https://aws.amazon.com/api-gateway/){:target="_blank"} REST endpoint to invoke your function.

- **REST API** creates a full REST API using [Amazon API Gateway](https://aws.amazon.com/api-gateway/){:target="_blank"} to add, update, select, and remove items in an [Amazon DynamoDB](https://aws.amazon.com/dynamodb/){:target="_blank"} database. API Gateway uses Lambda functions written in Swift to handle each action.

- **GraphQL API** creates an [AWS AppSync](https://aws.amazon.com/appsync/){:target="_blank"} GraphQL API that queries location data from the [Amazon Location Service](https://aws.amazon.com/location/){:target="_blank"}. It also queries weather data from a 3rd party weather API. AppSync uses Lambda functions written in Swift to handle each action.

## License

This library is licensed under the MIT-0 License. See the [LICENSE](https://github.com/aws-samples/aws-sam-swift/blob/main/LICENSE){:target="_blank"} file in the project code repository.

