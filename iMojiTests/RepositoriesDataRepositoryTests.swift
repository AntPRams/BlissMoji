@testable import iMoji
import XCTest

final class RepositoriesDataRepositoryTests: XCTestCase {
    
    var service: GithubServiceMock<[RepositoryModel]>!
    var sut: RepositoriesDataRepository!
    
    override func setUp() {
        super.setUp()
        
        service = GithubServiceMock<[RepositoryModel]>(mockUrl: .validReposList)
        sut = RepositoriesDataRepository(service: service)
    }
    
    override func tearDown() {
        sut = nil
        service = nil
        
        super.tearDown()
    }
    
    func test_fetchRepos() async throws {
        let repositories = try await sut.fetchRepositories(user: "stub", page: 1, resultsPerPage: 1)
        
        XCTAssertEqual(repositories.count, 3)
        XCTAssertEqual(repositories[0].name, "1")
        XCTAssertEqual(repositories[2].name, "3")
    }
}
