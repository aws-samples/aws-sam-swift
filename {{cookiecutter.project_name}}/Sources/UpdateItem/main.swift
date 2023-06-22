// import the packages required by our function
import Foundation
import AWSLambdaRuntime
import AWSLambdaEvents
import AWSDynamoDB

// define Codable struct for function response
struct Item : Codable {
    var id: String?
    let itemName: String
}

enum FunctionError: Error {
    case envError
    case apiError
}

@main
struct UpdateItem: SimpleLambdaHandler {

    // Lambda Function handler
    func handle(_ event: APIGatewayV2Request, context: LambdaContext) async throws -> Item {
        
        print("events received:\(event)")
        
        // create a client to interact with DynamoDB
        let client = try await DynamoDBClient()

        // obtain DynamoDB table name from function's environment variables
        guard let tableName = ProcessInfo.processInfo.environment["TABLE_NAME"] else {
            throw FunctionError.envError
        }

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
        
         // use the sdk to update the item in DynamoDB
        let input = UpdateItemInput(
            expressionAttributeValues: attrValues,
            key: ["id": .s(item.id!)],
            tableName: tableName,
            updateExpression: updateExpression
        )
        
        _ = try await client.updateItem(input: input)

        return item
    }
}