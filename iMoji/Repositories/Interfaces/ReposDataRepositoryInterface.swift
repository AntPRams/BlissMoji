import Foundation

/// A protocol defining methods for interacting with repository data.
protocol ReposDataRepositoryInterface: AnyObject {
    /// Initializes a data repository with the provided service.
        ///
        /// - Parameter service: A service for repository data.
    init(service: any Service)
    
    /// Asynchronously fetches repositories of a user with optional parameters.
    ///
    /// - Parameters:
    ///   - user: The username of repositories that should be retrived.
    ///   - page: The page number.
    ///   - resultPerPage: The number of results per page.
    /// - Returns: An array of `RepoModel` representing repositories of the user.
    /// - Throws: An error if the fetch operation fails.
    func fetchRepos(
        user: String,
        page: Int,
        resultsPerPage: Int
    ) async throws -> [RepoModel]
}
