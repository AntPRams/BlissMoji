@testable import iMoji
import XCTest
import Foundation

final class ListViewModelTests: XCTestCase {
    
    var service: GithubServiceMock<[RepositoryModel]>!
    var repository: RepositoriesDataRepository!
    var sut: ListViewModel!
    
    override func setUp() {
        super.setUp()
        setSut()
    }
    
    override func tearDown() {
        sut = nil
        service = nil
        repository = nil
        super.tearDown()
    }
    
    func test_fetchRepositories() async throws {
        XCTAssertTrue(sut.repositoriesData.isEmpty)
        
        sut.fetchRepositories()
        
        try await Task.sleep(nanoseconds: 300_000_000)
        
        XCTAssertEqual(sut.repositoriesData.count, 3)
        XCTAssertEqual(sut.repositoriesData[0].name, "1")
        XCTAssertEqual(sut.repositoriesData[2].name, "3")
    }
    
    func test_fetchRepositoriesWithNoResults() async throws {
        setSut(repositoriesMockPayload: .validEmptyReposList)
        
        sut.fetchRepositories()
        
        try await Task.sleep(nanoseconds: 300_000_000)
        
        XCTAssertTrue(sut.repositoriesData.isEmpty)
        XCTAssertFalse(sut.isMoreDataAvailable)
    }
    
    func test_fetchRepositoriesWithInvalidRequest() async throws {
        setSut(repositoriesMockPayload: .invalidEmojiList)
        
        XCTAssertNil(sut.error)
        
        sut.fetchRepositories()
        
        try await Task.sleep(nanoseconds: 300_000_000)
        
        XCTAssertEqual(sut.error?.localizedDescription, "The data couldn’t be read because it isn’t in the correct format.")
        XCTAssertFalse(sut.isMoreDataAvailable)
    }
}

private extension ListViewModelTests {
    
    func setSut(repositoriesMockPayload: MockDataFile = .validReposList) {
        service = GithubServiceMock<[RepositoryModel]>(mockUrl: repositoriesMockPayload)
        repository = RepositoriesDataRepository(service: service)
        sut = ListViewModel(repository: repository)
    }
}
