@testable import iMoji
import XCTest
import Foundation
import Combine

final class ImagesGridViewModelTests: XCTestCase {
    
    var repository: PersistentDataRepository!
    var sut: ImagesGridViewModel!
    var disposableBag: Set<AnyCancellable>!
    
    /// If your setup or teardown code needs to run on the Main actor, specify `@MainActor` for any asynchronous Swift setup or teardown methods you define.
    ///
    ///  More info here: https://developer.apple.com/documentation/xctest/xctestcase/set_up_and_tear_down_state_in_your_tests
    @MainActor
    override func setUp() async throws {
        try await super.setUp()
        setSut()
        disposableBag = Set<AnyCancellable>()
        
        await self.repository.deleteAllData()
    }
    
    @MainActor
    override func tearDown() async throws {
        await self.repository.deleteAllData()
        sut = nil
        repository = nil
        disposableBag = nil
        
        try await super.tearDown()
    }
    
    func test_fetchValidEmojis() async throws {
        XCTAssertEqual(sut.data.count, 0)
        sut.fetchData()
        
        try await Task.sleep(nanoseconds: 300_000_000)
        
        XCTAssertEqual(sut.data.count, 4)
        XCTAssertEqual(sut.data[0].type, ItemType.emoji.rawValue)
    }
    
    func test_fetchValidUser() async throws {
        XCTAssertEqual(sut.data.count, 0)
        /// Sets the data on repository to be able to try fetch as avatar since `ImagesGridViewModel` does not fetch avatars from network
        setSut(gridDataType: .avatar)
        _ = try await sut.repository.fetchAvatar(user: "apple")
        
        sut.fetchData()
        
        try await Task.sleep(nanoseconds: 300_000_000)
        
        XCTAssertEqual(sut.data.count, 1)
        XCTAssertEqual(sut.data[0].type, ItemType.avatar.rawValue)
        XCTAssertEqual(sut.data[0].name, "apple")
    }
    
    func test_fetchEmojisWithInvalidRequest() async throws {
        setSut(emojiMockPayload: .invalidEmojiList)
        XCTAssertNil(sut.error)
        sut.fetchData()
        
        try await Task.sleep(nanoseconds: 300_000_000)
        
        XCTAssertEqual(sut.data.count, 0)
        XCTAssertNotNil(sut.error)
        XCTAssertEqual(sut.error?.localizedDescription, "The data couldn’t be read because it isn’t in the correct format.")
    }
    
    func test_removeElementAtIndex() async throws {
        sut.fetchData()

        try await Task.sleep(nanoseconds: 500_000_000)
        
        XCTAssertEqual(sut.data.count, 4)
        XCTAssertEqual(sut.data[0].type, ItemType.emoji.rawValue)
        
        sut.removeElement(at: 0)
        
        XCTAssertEqual(sut.data.count, 3)
        XCTAssertEqual(sut.data[0].type, ItemType.emoji.rawValue)
    }
    
    func test_userRemovalNotification() async throws {
        let expectation = XCTestExpectation(description: "Did receive notification")
        subscribeToUserRemovalNotification(expectaction: expectation, name: "apple")
        
        /// Sets the data on repository to be able to try fetch as avatar since `ImagesGridViewModel` does not fetch avatars from network
        setSut(gridDataType: .avatar)
        _ = try await sut.repository.fetchAvatar(user: "apple")

        sut.fetchData()
        
        try await Task.sleep(nanoseconds: 300_000_000)
        
        XCTAssertEqual(sut.data.count, 1)
        XCTAssertEqual(sut.data[0].name, "apple")
        
        sut.removeElement(at: 0)
        
        XCTAssertEqual(sut.data.count, 0)
        
        await fulfillment(of: [expectation], timeout: 0.3)
    }
}

private extension ImagesGridViewModelTests {
    func setSut(
        emojiMockPayload: MockDataFile = .emojiList,
        avatarMockPayload: MockDataFile = .validUserData,
        gridDataType: ItemType = .emoji
    ) {
        let emojiService = GithubServiceMock<[String: String]>(mockUrl: emojiMockPayload)
        let avatarService = GithubServiceMock<AvatarModel>(mockUrl: avatarMockPayload)
        repository = PersistentDataRepository(
            avatarsService: avatarService,
            emojisService: emojiService
        )
        sut = ImagesGridViewModel(repository: repository, gridDataType: gridDataType)
    }
    
    func subscribeToUserRemovalNotification(expectaction: XCTestExpectation, name: String) {
        NotificationCenter.default.publisher(for: .didRemoveAvatarFromPersistence)
            .compactMap { $0.object as? String }
            .sink { avatarName in
                XCTAssertEqual(avatarName, name)
                expectaction.fulfill()
            }
            .store(in: &disposableBag)
    }
}
