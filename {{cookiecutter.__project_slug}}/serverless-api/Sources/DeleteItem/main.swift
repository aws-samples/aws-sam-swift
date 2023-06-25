// import the packages required by our function
import Foundation
import AWSLambdaRuntime
import AWSLambdaEvents
import AWSDynamoDB

// define Codable struct for function response
struct EmptyResponse : Codable {}

enum FunctionError: Error {
    case envError
    case apiError
}

@main
struct DeleteItem: SimpleLambdaHandler {

    // Lambda Function handler
    func handle(_ event: APIGatewayV2Request, context: LambdaContext) async throws -> EmptyResponse {
        
        print("event received:\(event)")
        
        // create a client to interact with DynamoDB
        let client = try await DynamoDBClient()

        // obtain DynamoDB table name from function's environment variables
        guard let tableName = ProcessInfo.processInfo.environment["TABLE_NAME"] else {
            throw FunctionError.envError
        }

        // obtain requested item id from path parameters
        guard let id = event.pathParameters!["id"] else {
            throw FunctionError.apiError
        }

        // use SDK to put the item into the database and return the item with key value
        let input = DeleteItemInput(key: ["id": .s(id)], tableName: tableName)
        
        _ = try await client.deleteItem(input: input)

        return EmptyResponse()
    }
}