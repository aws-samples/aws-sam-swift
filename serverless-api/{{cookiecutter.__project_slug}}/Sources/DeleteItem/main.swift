// import the packages required by our function
import Foundation
import AWSLambdaRuntime
import AWSLambdaEvents
@preconcurrency import AWSDynamoDB

// define Codable struct for function response
struct EmptyResponse : Codable {}

enum FunctionError: Error {
    case appError
}

let client = try await DynamoDBClient()

let runtime = LambdaRuntime {
    (event: APIGatewayV2Request, context: LambdaContext) async throws -> APIGatewayV2Response in

    print("event received:\(event)")

    // obtain DynamoDB table name from function's environment variables
    guard let tableName = ProcessInfo.processInfo.environment["TABLE_NAME"] else {
        throw FunctionError.appError
    }

    var response: APIGatewayV2Response

    do {
        // obtain requested item id from path parameters
        guard let id = event.pathParameters!["id"] else {
            throw FunctionError.appError
        }

        // use SDK to put the item into the database and return the item with key value
        let input = DeleteItemInput(key: ["id": .s(id)], tableName: tableName)
        
        _ = try await client.deleteItem(input: input)

        response = APIGatewayV2Response(
            statusCode: .ok, 
            body: String(data: try JSONEncoder().encode(EmptyResponse()), encoding: .utf8)!
        )

    } catch {
        context.logger.error("\(error)")
        response = APIGatewayV2Response(statusCode: .internalServerError, body: "[ERROR] \(error)")
    }

    return response
}

try await runtime.run()
