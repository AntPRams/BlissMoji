@testable import iMoji
import XCTest

final class PersistentDataRepositoryTests: XCTestCase {
    
    var emojiService: GithubServiceMock<[String: String]>!
    var avatarService: GithubServiceMock<AvatarModel>!
    var sut: PersistentDataRepository!
    
    override func setUp() {
        super.setUp()
        emojiService = GithubServiceMock<[String: String]>(mockUrl: .emojiList)
        avatarService = GithubServiceMock<AvatarModel>(mockUrl: .emojiList)
        sut = PersistentDataRepository(
            avatarsService: avatarService,
            emojisService: emojiService
        )
    }
    
    override func tearDown() {
        sut = nil
        avatarService = nil
        emojiService = nil
        super.tearDown()
    }
    
    func test_fetchEmojisDataRemovingModelsWithoutAProperURL() async {
        await self.sut.deleteAllData()
        
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
        } catch {
            XCTAssertEqual(error.localizedDescription, "The data couldn’t be read because it isn’t in the correct format.")
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
            let _ = try await sut.fetchImage(with: URL(string: "https://www.apple.com")!)
            await fulfillment(of: [emojiService.expectation], timeout: 0.1)
        } catch {
            XCTFail("Should not trigger error")
        }
    }
    
    func test_fetchImageWithError() async {
        do {
            let imageData = try await sut.fetchImage(with: URL(string: "https://www.error.com")!)
        } catch {
            XCTAssertEqual(error as? NetworkError, NetworkError.noData)
        }
    }
}

private extension PersistentDataRepositoryTests {
    func setSut(emojiMockPayload: MockDataFile = .emojiList, avatarMockPayload: MockDataFile = .emojiList) {
        emojiService = GithubServiceMock<[String: String]>(mockUrl: emojiMockPayload)
        avatarService = GithubServiceMock<AvatarModel>(mockUrl: avatarMockPayload)
        sut = PersistentDataRepository(
            avatarsService: avatarService,
            emojisService: emojiService
        )
    }
}

