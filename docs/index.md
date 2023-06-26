# Server-side Swift on AWS with SAM

This project contains a Cookiecutter template to create a serverless application based on the [AWS Serverless Application Model (SAM)](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-specification.html) and Swift.


## Get the Tools

To deploy an application based on this template, you need an AWS account and the following tools on your development machine. While it may work with alternative versions, we recommend you deploy the specified minimum version.

* [AWS Command Line Interface (AWS CLI)](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) (^2.4.19) the AWS CLI is used to configure the AWS credentials on your development machine.
* [SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/install-sam-cli.html) (^1.82.0)
* [Docker Desktop](https://www.docker.com/products/docker-desktop) (^4.19) SAM uses Docker to compile the Swift Lambda functions for Linux disribution to AWS Lambda.


## Create a Project

``` bash
sam init --location gh:aws-samples/aws-sam-swift
```

When prompted, specify a name for your project and select the template for the type of project you want to generate. Then switch to the project's folder. 

Instructions to build and deploy the application are located in the **README.md** file of the generated project.

## Security

See [CONTRIBUTING](../CONTRIBUTING.md.md#security-issue-notifications) for more information.

## License

This library is licensed under the MIT-0 License. See the [LICENSE](../LICENSE) file.

