// import the packages required by our function
import Foundation
import AWSLambdaRuntime
import AWSLambdaEvents
import AWSDynamoDB

// define Codable struct for function response
struct Item : Codable {
    var id: String = ""
    var itemName: String = ""
}

enum FunctionError: Error {
    case envError
    case apiError
}

@main
struct GetItem: SimpleLambdaHandler {

    // Lambda Function handler
    func handle(_ event: APIGatewayV2Request, context: LambdaContext) async throws -> Item {
        
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

        // use the sdk to retrieve the item from DynamoDB
        let input = GetItemInput(key: ["id": .s(id)], tableName: tableName)
        let response = try await client.getItem(input: input)
        
        guard let responseItem = response.item else {
            throw FunctionError.apiError
        }
        
        // create response object and return
        var item = Item(id: id)

        if case .s(let value) = responseItem["itemName"] {
            item.itemName = value
        }

        return item
    }
}