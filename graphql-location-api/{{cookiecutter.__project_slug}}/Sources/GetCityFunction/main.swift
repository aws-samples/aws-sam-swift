import AWSLambdaRuntime
import Foundation
@preconcurrency import AWSLocation

// define struct for function event arguments
struct Event: Codable {
    let arguments: Arguments
}

struct Arguments: Codable {
    let latitude: Double
    let longitude: Double
}

// define struct for the output of the lambda function
struct Location: Codable {
    let name: String
    let latitude: Double
    let longitude: Double
}

// define function error types
enum FunctionError: Error {
    case envError
}

// function to retrieve the function environment variables by name
func getEnvVariable(name: String) throws -> String {
    
    guard let value = ProcessInfo.processInfo.environment[name] else {
        throw FunctionError.envError
    }
    
    return value
}

// function to flatten the Amazon Location results into the Location format
func getCity (item: LocationClientTypes.SearchForPositionResult) -> Location {
    
    let municipality = item.place!.municipality ?? ""
    let region = item.place!.region ?? ""
    let name = String("\(municipality), \(region)").trimmingCharacters(in: .whitespacesAndNewlines)

    return Location(
        name:  name,
        latitude: item.place!.geometry!.point![0],
        longitude: item.place!.geometry!.point![1]
    )
}

// define an Amazon Location Service client
let client = try await LocationClient()

// Lambda Handler
let runtime = LambdaRuntime {
    (event: Event, context: LambdaContext) async throws -> Location in

    print("received event: \(event)")
    
    // get the name of the Amazon Location Place Index from the environment variable set with the CDK
    let placeIndexName = try getEnvVariable(name: "PLACE_INDEX_NAME")
    
    // construct the place index search parameters
    let input = SearchPlaceIndexForPositionInput(
        indexName: placeIndexName,
        maxResults: 1,
        position: [event.arguments.longitude, event.arguments.latitude]
    )

    let response = try await client.searchPlaceIndexForPosition(input: input)

    return getCity(item: response.results![0])
}

try await runtime.run()
