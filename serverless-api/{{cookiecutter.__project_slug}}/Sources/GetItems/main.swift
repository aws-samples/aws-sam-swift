// import the packages required by our function
import Foundation
import AWSLambdaRuntime
import AWSLambdaEvents
@preconcurrency import AWSDynamoDB

// define Codable struct for function response
struct Item : Codable {
    var id: String?
    var itemName: String

    init(id: String? = nil, itemName: String = "") {
        self.id = id
        self.itemName = itemName
    }
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

    var output: APIGatewayV2Response

    do {
        // use SDK to retrieve items from table
        let input = ScanInput(tableName: tableName)
        let response = try await client.scan(input: input)
        
        // return items in an array
        let items = response.items!.map() {i in
            let id = i["id"].flatMap { if case .s(let value) = $0 { return value } else { return nil } }
            let itemName = i["itemName"].flatMap { if case .s(let value) = $0 { return value } else { return "" } } ?? ""

            let item = Item(id: id, itemName: itemName)

            return item
        }

        output = APIGatewayV2Response(
            statusCode: .ok, 
            body: String(data: try JSONEncoder().encode(items), encoding: .utf8)!
        )

    } catch {
        context.logger.error("\(error)")
        output = APIGatewayV2Response(statusCode: .internalServerError, body: "[ERROR] \(error)")
    }

    return output
}

try await runtime.run()
