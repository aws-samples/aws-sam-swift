// import the packages required by our function
import AWSLambdaRuntime

struct Request: Codable {
    let rawPath: String
}

struct Response: Codable {
    let body: String
}

@main
struct HelloWorld: SimpleLambdaHandler {

    // Lambda Function handler
    func handle(_ event: Request, context: LambdaContext) async throws -> Response {

        return Response(body:"Hello from AWS")
    }
}
