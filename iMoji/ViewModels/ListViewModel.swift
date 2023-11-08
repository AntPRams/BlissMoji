import Foundation

@Observable 
class ListViewModel {
    
    // MARK: - Properties
    
    let repository: RepositoriesDataRepositoryInterface
    var error: Error?
    var viewState: ViewState = .initial
    var repositoriesData = [RepositoryModel]()
    var isMoreDataAvailable: Bool = true
    private var currentPage = 1
    
    // MARK: - Init
    
    init(repository: RepositoriesDataRepositoryInterface = RepositoriesDataRepository()) {
        self.repository = repository
    }
    
    // MARK: - Public Interface
    
    func fetchRepositories() {
        guard isMoreDataAvailable else { return }
        viewState = .loading
        Task { [weak self] in
            guard let self else { return }
            do {
                let repos = try await repository.fetchRepositories(
                    user: "apple",
                    page: currentPage,
                    resultsPerPage: 10
                )
                await MainActor.run {
                    if repos.isEmpty {
                        self.isMoreDataAvailable = false
                    } else {
                        self.currentPage += 1
                        self.repositoriesData.append(contentsOf: repos)
                    }
                    self.viewState = .idle
                }
            } catch {
                await MainActor.run {
                    self.error = error
                    self.viewState = .idle
                    self.isMoreDataAvailable = false
                }
            }
        }
    }
}
