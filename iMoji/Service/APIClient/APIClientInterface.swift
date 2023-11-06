import Foundation

/// The `APIClientInterface` protocol defines an interface for a network client capable of making asynchronous network requests and handling responses.
protocol APIClientInterface {
    /// Asynchronously fetches data from the provided URL.
    ///
    /// - Parameters:
    ///   - url: The URL to fetch data from.
    ///
    /// - Returns: The fetched binary data.
    ///
    /// - Throws: An error if the network request or response handling encounters a problem.
    func fetch(from url: URL) async throws -> Data
    
    /// Asynchronously fetches and decodes data of a specific type from the provided URL.
    ///
    /// - Parameters:
    ///   - url: The URL to fetch data from.
    ///
    /// - Returns: The decoded data of the specified type, or `nil` if the decoding fails.
    ///
    /// - Throws: An error if the network request, response handling, or decoding encounters a problem.
    func fetch<T: Decodable>(from url: URL) async throws -> T?
}

