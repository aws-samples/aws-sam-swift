// import the packages required by our function
import Foundation
import AWSLambdaRuntime
import AWSLambdaEvents
@preconcurrency import AWSDynamoDB

// define Codable struct for function response
struct Item : Codable {
    var id: String?
    let itemName: String
}

enum FunctionError: Error {
    case envError
}

let client = try await DynamoDBClient()

let runtime = LambdaRuntime {
    (event: APIGatewayV2Request, context: LambdaContext) async throws -> APIGatewayV2Response in

    print("event received:\(event)")

    // obtain DynamoDB table name from function's environment variables
    guard let tableName = ProcessInfo.processInfo.environment["TABLE_NAME"] else {
        throw FunctionError.envError
    }

    var response: APIGatewayV2Response

    do {
        // decode data from APIGateway POST into a codable struct
        var item = try JSONDecoder().decode(
            Item.self, 
            from: event.body!.data(using: .utf8)!
        )

        // generate a unique id for the key of the item
        item.id = UUID().uuidString
        let conditionExpression: String = "attribute_not_exists(id)"

        // use SDK to put the item into the database and return the item with key value
        let input = PutItemInput(
            conditionExpression: conditionExpression,
            item: ["id": .s(item.id!), "itemName": .s(item.itemName)], 
            tableName: tableName
        )

        _ = try await client.putItem(input: input)

        response = APIGatewayV2Response(
            statusCode: .ok, 
            body: String(data: try JSONEncoder().encode(item), encoding: .utf8)!
        )

    } catch {
        context.logger.error("\(error)")
        response = APIGatewayV2Response(statusCode: .internalServerError, body: "[ERROR] \(error)")
    }

    return response
}

try await runtime.run()
