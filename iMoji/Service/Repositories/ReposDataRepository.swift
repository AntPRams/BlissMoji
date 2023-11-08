import Foundation

final class ReposDataRepository {
    
    // MARK: - Properties
    
    private let service: any Service
    
    // MARK: - Init
    
    init(service: any Service = GithubService<[RepoModel]>()) {
        self.service = service
    }
    
    // MARK: - Public interface
    
    @discardableResult
    func fetchRepos(page: Int, resultPerPage: Int = 10) async throws -> [RepoModel] {
        if let data = try await service.fetchData(
            from: .repos(
                user: "apple",
                page: page,
                size: resultPerPage
            )
        ) as? [RepoModel] {
            return data
        }
        return []
    }
}
