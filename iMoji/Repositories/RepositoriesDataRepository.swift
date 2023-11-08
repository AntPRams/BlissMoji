import Foundation

final class RepositoriesDataRepository: RepositoriesDataRepositoryInterface {
    
    // MARK: - Properties
    
    private let service: any Service
    
    // MARK: - Init
    
    init(service: any Service = GithubService<[RepositoryModel]>()) {
        self.service = service
    }
    
    // MARK: - Public interface
    
    func fetchRepositories(
        user: String,
        page: Int,
        resultsPerPage: Int
    ) async throws -> [RepositoryModel] {
        
        if let data = try await service.fetchData(
            from: .repositories(
                user: user,
                page: page,
                size: resultsPerPage
            )
        ) as? [RepositoryModel] {
            return data
        }
        return []
    }
}
