import Foundation

final class ReposDataRepository: ReposDataRepositoryInterface {
    
    // MARK: - Properties
    
    private let service: any Service
    
    // MARK: - Init
    
    init(service: any Service = GithubService<[RepoModel]>()) {
        self.service = service
    }
    
    // MARK: - Public interface
    
    func fetchRepos(
        user: String,
        page: Int,
        resultsPerPage: Int
    ) async throws -> [RepoModel] {
        
        if let data = try await service.fetchData(
            from: .repos(
                user: user,
                page: page,
                size: resultsPerPage
            )
        ) as? [RepoModel] {
            return data
        }
        return []
    }
}
