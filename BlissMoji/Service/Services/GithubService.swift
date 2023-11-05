import Foundation

/// The `GithubService` class is an implementation of the `Service` protocol, designed to fetch data and images from GitHub endpoints.
///
/// Conforms to: `Service`
///
/// Type Parameters:
///   - Model: The data type to be fetched and decoded. Must conform to the `Decodable` protocol.
final class GithubService<Model: Decodable>: Service {

    /// The associated type `DataType` represents the type of data that can be fetched from a remote endpoint. It will be represented as `Model`.
    typealias DataType = Model
    
    // MARK: - Properties
    
    /// The API client responsible for making network requests.
    private var apiClient: APIClientInterface
    
    // MARK: - Init
    
    init(apiClient: APIClientInterface = APIClient()) {
        self.apiClient = apiClient
    }
    
    // MARK: - Public interface
    
    func fetchData(from endPoint: EndPoint) async throws -> Model {
        guard let url = endPoint.url else {
            throw NetworkError.unknown
        }
        
        let data: Model? = try await apiClient.fetch(from: url)
        
        guard let resultData = data else {
            throw NetworkError.noData
        }
        
        return resultData
    }
    
    func fetchImage(from url: URL) async throws -> Data {
        try await apiClient.fetch(from: url)
    }
}
