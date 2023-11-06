import XCTest
@testable import BlissMoji

final class BlissMojiTests: XCTestCase {
    
    var service: GithubServiceMock<[String: String]>!
    var sut: EmojiAdapter!
    
    override func setUp() {
        super.setUp()
        service = GithubServiceMock<[String: String]>(mockUrl: .emojiList)
        sut = EmojiAdapter(service: service)
    }
    
    override func tearDown() {
        sut = nil
        service = nil
        super.tearDown()
    }
    
    func test_fetchEmojisDataRemovingModelsWithoutAProperURL() async {
        do {
            let data = try await sut.fetchEmojisData()
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
        service = GithubServiceMock<[String: String]>(mockUrl: .invalidEmojiList)
        sut = EmojiAdapter(service: service)
        do {
            let _ = try await sut.fetchEmojisData()
        } catch {
            XCTAssertEqual(error.localizedDescription, "The data couldn’t be read because it isn’t in the correct format.")
        }
    }
    
    func test_fetchRandomEmoji() async {
        let emoji = await sut.fetchRandomEmoji()
        
        XCTAssertNotNil(emoji?.name)
        XCTAssertNotNil(emoji?.imageUrl)
        XCTAssertNil(emoji?.imageData)
    }
    
    func test_fetchImageSuccessExpectation() async {
        do {
            let emojiModel = EmojiModel(name: "Some", imageUrl: URL(string: "https://www.apple.com")!)
            let _ = try await sut.fetchImage(for: emojiModel)
            await fulfillment(of: [service.expectation], timeout: 0.1)
        } catch {
            XCTFail("Should not trigger error")
        }
    }
    
    func test_fetchImageWithError() async {
        do {
            let emojiModel = EmojiModel(name: "Some", imageUrl: URL(string: "https://www.error.com")!)
            let imageData = try await sut.fetchImage(for: emojiModel)
        } catch {
            XCTAssertEqual(error as? NetworkError, NetworkError.noData)
        }
    }
}
