import Foundation

final class GithubService<Model: Decodable>: Service {

    typealias DataType = Model
    
    // MARK: - Properties
    
    private var apiClient: APIClientInterface
    
    // MARK: - Init
    
    init(
        apiClient: APIClientInterface = APIClient()
    ) {
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
