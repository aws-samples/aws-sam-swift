// import the packages required by our function
import Foundation
import AWSLambdaRuntime
import AWSLambdaEvents
@preconcurrency import AWSDynamoDB

// define Codable struct for function response
struct Item : Codable {
    var id: String?
    var itemName: String
}

enum FunctionError: Error {
    case envError
    case apiError
}

let client = try await DynamoDBClient()

let runtime = LambdaRuntime {
    (event: APIGatewayV2Request, context: LambdaContext) async throws -> APIGatewayV2Response in

    print("event received:\(event)")

    // obtain DynamoDB table name from function's environment variables
    guard let tableName = ProcessInfo.processInfo.environment["TABLE_NAME"] else {
        throw FunctionError.envError
    }

    var output: APIGatewayV2Response

    do {
        // obtain requested item id from path parameters
        guard let id = event.pathParameters!["id"] else {
            throw FunctionError.apiError
        }

        // use the sdk to retrieve the item from DynamoDB
        let input = GetItemInput(key: ["id": .s(id)], tableName: tableName)
        let response = try await client.getItem(input: input)
        
        guard let responseItem = response.item else {
            throw FunctionError.apiError
        }
        
        // create response object and return
        var item = Item(id: id, itemName: "")

        if case .s(let value) = responseItem["itemName"] {
            item.itemName = value
        }

        output = APIGatewayV2Response(
            statusCode: .ok, 
            body: String(data: try JSONEncoder().encode(item), encoding: .utf8)!
        )

    } catch {
        context.logger.error("\(error)")
        output = APIGatewayV2Response(statusCode: .internalServerError, body: "[ERROR] \(error)")
    }

    return output
}

try await runtime.run()
