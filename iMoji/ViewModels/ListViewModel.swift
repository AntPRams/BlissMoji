import Foundation

@Observable 
class ListViewModel {
    
    // MARK: - Properties
    
    let repository: ReposDataRepositoryInterface
    var error: Error?
    var viewState: ViewState = .initial
    var reposData = [RepoModel]()
    var isMoreDataAvailable: Bool = true
    private var currentPage = 1
    
    // MARK: - Init
    
    init(repository: ReposDataRepositoryInterface = ReposDataRepository()) {
        self.repository = repository
    }
    
    // MARK: - Public Interface
    
    func fetchRepos() {
        guard isMoreDataAvailable else { return }
        viewState = .loading
        Task { [weak self] in
            guard let self else { return }
            do {
                let repos = try await repository.fetchRepos(
                    user: "apple",
                    page: currentPage,
                    resultsPerPage: 10
                )
                await MainActor.run {
                    if repos.isEmpty {
                        self.isMoreDataAvailable = false
                    } else {
                        self.currentPage += 1
                        self.reposData.append(contentsOf: repos)
                    }
                    self.viewState = .idle
                }
            } catch {
                await MainActor.run {
                    self.error = error
                    self.viewState = .idle
                }
            }
        }
    }
}
