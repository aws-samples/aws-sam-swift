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
}

@main
struct GetItems: SimpleLambdaHandler {

    // Lambda Function handler
    func handle(_ event: APIGatewayV2Request, context: LambdaContext) async throws -> [Item] {
        
        print("event received:\(event)")
        
        // create a client to interact with DynamoDB
        let client = try await DynamoDBClient()

        // obtain DynamoDB table name from function's environment variables
        guard let tableName = ProcessInfo.processInfo.environment["TABLE_NAME"] else {
            throw FunctionError.envError
        }

        // use SDK to retrieve items from table
        let input = ScanInput(tableName: tableName)
        let response = try await client.scan(input: input)
        
        // return items in an array
        return response.items!.map() {i in
            var item = Item()

            if case .s(let value) = i["id"] {
                item.id = value
            }

            if case .s(let value) = i["itemName"] {
                item.itemName = value
            }

            return item
        }
    }
}