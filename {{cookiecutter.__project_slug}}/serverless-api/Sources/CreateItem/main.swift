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
}

@main
struct CreateItem: SimpleLambdaHandler {

    // Lambda Function handler
    func handle(_ event: APIGatewayV2Request, context: LambdaContext) async throws -> Item {
        
        print("event received:\(event)")
        
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

        return item
    }
}