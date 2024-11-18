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
        // decode data from APIGateway POST into a codable struct
        var item = try JSONDecoder().decode(
            Item.self, 
            from: event.body!.data(using: .utf8)!
        )

        // obtain requested item id from path parameters
        item.id = event.pathParameters!["id"]!

        // build the update expression
        var expressionParts: [String] = []
        var attrValues: [String:DynamoDBClientTypes.AttributeValue] = [:]
        
        expressionParts.append(("itemName=:i"))
        attrValues[":i"] = .s(item.itemName)
        let updateExpression: String = "set \(expressionParts.joined(separator: ", "))"
        let conditionExpression: String = "attribute_exists(id)"
        
         // use the sdk to update the item in DynamoDB
        let input = UpdateItemInput(
            conditionExpression: conditionExpression,
            expressionAttributeValues: attrValues,
            key: ["id": .s(item.id!)],
            tableName: tableName,
            updateExpression: updateExpression
        )
        
        _ = try await client.updateItem(input: input)

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
