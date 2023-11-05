import Foundation

final class APIClient: APIClientInterface {
    
    func fetch(from url: URL) async throws -> Data {
        let request = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: request)
        let mapResponse = try mapResponse(response: (data,response))
        return mapResponse
    }
    
    func fetch<T: Decodable>(from url: URL) async throws -> T? {
        let data = try await fetch(from: url)
        let fetchedData = try JSONDecoder().decode(T.self, from: data)
        return fetchedData
    }
}

extension APIClient {
    
    /// Maps an HTTP response to the corresponding HTTP status code and handles specific errors.
    ///
    /// - Parameter response: The response data and HTTP response object.
    ///
    /// - Returns: The response data as binary data.
    ///
    /// - Throws: An error corresponding to the HTTP status code or a generic `NetworkError.unknown` if the status code is not recognized.
    private func mapResponse(response: (data: Data, response: URLResponse)) throws -> Data {
        guard let httpResponse = response.response as? HTTPURLResponse else {
            return response.data
        }
        
        switch httpResponse.statusCode {
        case 200..<300:
            return response.data
        case 300..<400:
            throw NetworkError.redirected
        case 400:
            throw NetworkError.badRequest
        case 401:
            throw NetworkError.unauthorized
        case 403:
            throw NetworkError.forbidden
        case 404:
            throw NetworkError.notFound
        case 500..<600:
            throw NetworkError.serverError
        default:
            throw NetworkError.unknown
        }
    }
}

