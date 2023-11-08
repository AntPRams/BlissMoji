@testable import iMoji
import XCTest

final class ReposDataRepositoryTests: XCTestCase {
    
    var service: GithubServiceMock<RepositoryModel>!
    var sut: RepositoriesDataRepository!
    
    /// If your setup or teardown code needs to run on the Main actor, specify `@MainActor` for any asynchronous Swift setup or teardown methods you define.
    ///
    /// More info here: https://developer.apple.com/documentation/xctest/xctestcase/set_up_and_tear_down_state_in_your_tests
    @MainActor
    override func setUp() async throws {
        try await super.setUp()
        service = GithubServiceMock<RepositoryModel>(mockUrl: .validReposList)
        sut = PersistentDataRepository(
            avatarsService: avatarService,
            emojisService: emojiService
        )
        
        await self.sut.deleteAllData()
    }
    
    @MainActor
    override func tearDown() async throws {
        await self.sut.deleteAllData()
        sut = nil
        avatarService = nil
        emojiService = nil
        
        try await super.tearDown()
    }
}
