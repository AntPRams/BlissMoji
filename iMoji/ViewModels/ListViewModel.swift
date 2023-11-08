import Foundation

@Observable class ListViewModel {
    
    var error: Error?
    var viewState: ViewState = .initial
    var repository: ReposDataRepository
    var reposData = [RepoModel]()
    var isMoreDataAvailable: Bool = true
    private var currentPage = 1
    
    init(repository: ReposDataRepository = ReposDataRepository()) {
        self.repository = repository
    }
    
    func fetchRepos() {
        guard isMoreDataAvailable else { return }
        viewState = .loading
        Task {
            do {
                let repos = try await repository.fetchRepos(page: currentPage)
                await MainActor.run {
                    if repos.isEmpty {
                        isMoreDataAvailable = false
                    } else {
                        currentPage += 1
                        reposData.append(contentsOf: repos)
                    }
                    viewState = .idle
                }
            } catch {
                await MainActor.run {
                    self.error = error
                    viewState = .idle
                }
            }
        }
    }
}
