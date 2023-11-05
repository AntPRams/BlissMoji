import Foundation

protocol APIClientInterface {
    func fetch(from url: URL) async throws -> Data
    func fetch<T: Decodable>(from url: URL) async throws -> T?
}

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

