@testable import iMoji
import XCTest
import Foundation

final class MainViewModelTests: XCTestCase {
    
    var repository: PersistentDataRepositoryMock!
    var sut: MainViewModel!
    
    override func setUp() {
        super.setUp()
        setSut()
    }
    
    override func tearDown() {
        sut = nil
        repository = nil
        super.tearDown()
    }
    
    func test_fetchRandomEmoji() async throws {
        XCTAssertNil(sut.displayedItem)
        sut.fetchRandomEmoji()
        
        /// At the moment there are no easy options to test models with the `@Observable` macro
        ///
        /// - Note: This issue is addressed on project Readme
        try await Task.sleep(nanoseconds: 300_000_000)
        
        XCTAssertNotNil(sut.displayedItem)
        XCTAssertEqual(sut.displayedItem?.type, ItemType.emoji.rawValue)
        XCTAssertEqual(sut.displayedItem?.imageUrl.absoluteString, "stub")
    }
    
    func test_searchUserWithoutQuery() async throws {
        XCTAssertNil(sut.error)
        sut.searchUser()
        
        try await Task.sleep(nanoseconds: 300_000_000)
        
        XCTAssertNil(sut.displayedItem)
        XCTAssertEqual(sut.error as? AppError, .userNameMissing)
    }
    
    func test_searchUserWithQuery() async throws {
        XCTAssertNil(sut.displayedItem)
        sut.query = "stub"
        sut.searchUser()
        
        try await Task.sleep(nanoseconds: 300_000_000)
        
        XCTAssertNotNil(sut.displayedItem)
        XCTAssertEqual(sut.displayedItem?.type, ItemType.avatar.rawValue)
        XCTAssertEqual(sut.displayedItem?.imageUrl.absoluteString, "stub")
    }
    
    func test_removeDisplayedUserIfNameIsEqual() async throws {
        sut.query = "stub"
        sut.searchUser()
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        XCTAssertNotNil(sut.displayedItem)
        XCTAssertEqual(sut.displayedItem?.type, ItemType.avatar.rawValue)
        
        postAvatarRemovalNotification(with: "avatar-stub")
        
        XCTAssertNil(sut.displayedItem)
    }
    
    func test_dontRemoveDisplayedUserIfNameIsNotEqual() async throws {
        sut.query = "stub"
        sut.searchUser()
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        XCTAssertNotNil(sut.displayedItem)
        XCTAssertEqual(sut.displayedItem?.type, ItemType.avatar.rawValue)
        
        postAvatarRemovalNotification(with: "avatar")
        
        XCTAssertNotNil(sut.displayedItem)
    }
    
    func test_errorIsBeingPopulatedWhenFetchFails() async throws {
        repository.error = NetworkError.badRequest
        XCTAssertNil(sut.error)
        sut.fetchEmojis()
        
        try await Task.sleep(nanoseconds: 300_000_000)
        
        XCTAssertEqual(sut.error as? NetworkError, .badRequest)
    }
}

private extension MainViewModelTests {
    
    func postAvatarRemovalNotification(with name: String) {
        NotificationCenter.default.post(
            name: .didRemoveAvatarFromPersistence,
            object: name
        )
    }
    
    func setSut(
        emojiMockPayload: MockDataFile = .emojiList,
        avatarMockPayload: MockDataFile = .validUserData
    ) {
        let emojiService = GithubServiceMock<[String: String]>(mockUrl: emojiMockPayload)
        let avatarService = GithubServiceMock<AvatarModel>(mockUrl: avatarMockPayload)
        repository = PersistentDataRepositoryMock(
            avatarsService: avatarService,
            emojisService: emojiService
        )
        sut = MainViewModel(repository: repository)
    }
}
