// import the packages required by our function
import AWSLambdaRuntime

struct Request: Codable {
    let rawPath: String
}

struct Response: Codable {
    let body: String
}

let runtime = LambdaRuntime {
    (event: Request, context: LambdaContext) async throws -> Response in

    return Response(body:"Hello from AWS")

}

try await runtime.run()
