import Foundation

/// The `Service` protocol defines the contract for a service that can fetch data and images from remote endpoints asynchronously using `async/await` syntax.
protocol Service: AnyObject {
    
    /// The associated type `DataType` represents the type of data that can be fetched from a remote endpoint. It must conform to the `Decodable` protocol.
    associatedtype DataType: Decodable
    
    /// Asynchronously fetches data from a given `EndPoint`.
    ///
    /// - Parameters:
    ///   - endPoint: An `EndPoint` object representing the remote endpoint to fetch data from.
    ///
    /// - Returns: The fetched data of the associated type `DataType`.
    ///
    /// - Throws: An error if the data fetching operation encounters a problem.
    func fetchData(from endPoint: EndPoint) async throws -> DataType
    
    /// Asynchronously fetches an image from a given URL.
    ///
    /// - Parameters:
    ///   - url: The URL from which to fetch the image.
    ///
    /// - Returns: The binary image data as `Data`
    ///
    /// - Throws: An error if the image fetch operation encounters a problem.
    func fetchImage(from url: URL) async throws -> Data
}
