@testable import iMoji
import XCTest

final class PersistentDataRepositoryTests: XCTestCase {
    
    var emojiService: GithubServiceMock<[String: String]>!
    var avatarService: GithubServiceMock<AvatarModel>!
    var sut: PersistentDataRepository!
    
    /// If your setup or teardown code needs to run on the Main actor, specify `@MainActor` for any asynchronous Swift setup or teardown methods you define.
    ///
    /// More info here: https://developer.apple.com/documentation/xctest/xctestcase/set_up_and_tear_down_state_in_your_tests
    @MainActor
    override func setUp() async throws {
        try await super.setUp()
        emojiService = GithubServiceMock<[String: String]>(mockUrl: .emojiList)
        avatarService = GithubServiceMock<AvatarModel>(mockUrl: .validUserData)
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
    
    func test_fetchEmojisDataRemovingModelsWithoutAProperURL() async {
        do {
            let data = try await sut.fetchItems(.emoji)
            _ = data.contains { model in
                if model.name == "4" {
                    XCTFail("Model should not be parsed since it contains a invalid URL")
                }
                return false
            }
            
            XCTAssertEqual(data.count, 4)
        } catch {
            XCTFail("Should not trigger error")
        }
    }
    
    func test_fetchEmojisFromInvalidList() async {
        setSut(emojiMockPayload: .invalidEmojiList)
        do {
            try await sut.fetchItems(.emoji)
            XCTFail("This request should fail")
        } catch {
            XCTAssertEqual(error.localizedDescription, "The data couldn’t be read because it isn’t in the correct format.")
        }
    }
    
    func test_fetchUserData() async {
        do {
            let data = try await sut.fetchAvatar(user: "stub")
            XCTAssertEqual(data.imageUrl.absoluteString, "https://avatars.githubusercontent.com/u/10639145?v=4")
            XCTAssertEqual(data.name, "apple")
            XCTAssertEqual(data.type, ItemType.avatar.rawValue) //1
        } catch {
            XCTFail("Should not trigger error")
        }
    }
    
    func test_fetchInvalidUserData() async {
        setSut(avatarMockPayload: .invalidUserData)
        
        do {
            _ = try await sut.fetchAvatar(user: "stub")
            XCTFail("This request should fail")
        } catch {
            XCTAssertEqual(error.localizedDescription, "The server could not understand the request.")
        }
    }
    
    func test_predicateFiltering() async {
        do {
            // Set items in persistence
            try await sut.fetchItems(.emoji)
            _ = try await sut.fetchAvatar(user: "stub")
            
            let avatars = try await sut.fetchItems(.avatar)
            
            XCTAssertEqual(avatars.count, 1)
            XCTAssertEqual(avatars[0].name, "apple")
            
            let emojis = try await sut.fetchItems(.emoji)
            
            XCTAssertEqual(emojis.count, 4)
            XCTAssertEqual(emojis[0].name, "1")
        } catch {
            XCTFail("Should not trigger error")
        }
    }
    
    func test_persistenceWhenDataIsAlreadyAvailable() async {
        do {
            avatarService.shouldTryFulfillExpectation = false
            emojiService.shouldTryFulfillExpectation = false
            // Set items in persistence
            try await sut.fetchItems(.emoji)
            _ = try await sut.fetchAvatar(user: "stub")
            
            avatarService.networkRequestExpectation.isInverted = true
            emojiService.networkRequestExpectation.isInverted = true
            
            avatarService.shouldTryFulfillExpectation = true
            emojiService.shouldTryFulfillExpectation = true
            
            try await sut.fetchItems(.emoji)
            _ = try await sut.fetchAvatar(user: "apple")
            
            await fulfillment(
                of: [emojiService.networkRequestExpectation, avatarService.networkRequestExpectation],
                timeout: 1
            )
        } catch {
            XCTFail("Should not trigger error")
        }
    }
    
    func test_removeUser() async {
        do {
            // Set items in persistence
            let avatar = try await sut.fetchAvatar(user: "stub")
            let avatars = try await sut.fetchItems(.avatar)
            
            XCTAssertEqual(avatars.count, 1)
            
            await sut.removeUser(with: avatar)
            
            let avatarsAfterDeletion = try await sut.fetchItems(.avatar)
            XCTAssertTrue(avatarsAfterDeletion.isEmpty)
            
        } catch {
            XCTFail("Should not trigger error")
        }
    }
    
    func test_fetchRandomEmoji() async {
        let emoji = try! await sut.fetchRandomEmoji()
        
        XCTAssertNotNil(emoji?.name)
        XCTAssertNotNil(emoji?.imageUrl)
        XCTAssertNil(emoji?.imageData)
    }
    
    func test_fetchImageSuccessExpectation() async {
        do {
            let _ = try await sut.fetchImage(with: URL(string: "https://www.stub.com")!)
            await fulfillment(of: [emojiService.imageRequestExpectation], timeout: 0.1)
        } catch {
            XCTFail("Should not trigger error")
        }
    }
    
    func test_fetchImageWithError() async {
        do {
            _ = try await sut.fetchImage(with: URL(string: "https://www.error.com")!)
        } catch {
            XCTAssertEqual(error as? NetworkError, NetworkError.noData)
        }
    }
}

private extension PersistentDataRepositoryTests {
    func setSut(
        emojiMockPayload: MockDataFile = .emojiList,
        avatarMockPayload: MockDataFile = .validUserData
    ) {
        emojiService = GithubServiceMock<[String: String]>(mockUrl: emojiMockPayload)
        avatarService = GithubServiceMock<AvatarModel>(mockUrl: avatarMockPayload)
        sut = PersistentDataRepository(
            avatarsService: avatarService,
            emojisService: emojiService
        )
    }
}
