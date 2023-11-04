import Foundation

protocol Service {
    associatedtype DataType
    func fetchConnections(url: URL?) async throws -> [DataType]
}

final class GithubService<Model: Decodable>: Service {
    typealias DataType = Model
    
    // MARK: - Properties
    
    private var apiClient: APIClientInterface
    private var url: URL?
    
    // MARK: - Init
    
    init(
        apiClient: APIClientInterface = APIClient()
    ) {
        self.apiClient = apiClient
    }
    
    // MARK: - Public interface
    
    func fetchConnections(url: URL?) async throws -> [Model] {
        guard let url else {
            throw NetworkError.unknown
        }
        
        let data: [Model]? = try await apiClient.fetch(from: url)
        
        guard
            let resultData = data,
            !resultData.isEmpty
        else {
            throw NetworkError.noData
        }
        
        return resultData
    }
}
