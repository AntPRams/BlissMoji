@testable import iMoji
import XCTest
import Foundation
import Combine

final class ImagesGridViewModelTests: XCTestCase {
    
    var adapter: EmojiAdapter!
    var sut: ImagesGridViewModel!
    var disposableBag: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        adapter = EmojiAdapter(service: GithubServiceMock<[String: String]>(mockUrl: .emojiList))
        sut = ImagesGridViewModel(
            emojisAdapter: adapter,
            avatarsAdapter: AvatarAdapter(),
            gridDataType: .emojis
        )
        disposableBag = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        sut = nil
        adapter = nil
        disposableBag = nil
        super.tearDown()
    }
    
    func test_fetchValidEmojis() {
        let expectation = XCTestExpectation(description: "Did receive emojis")
        sut.fetchData()
        
        sut.$data
            .dropFirst()
            .sink { emojis in
                XCTAssertEqual(emojis.count, 4)
                expectation.fulfill()
            }
            .store(in: &disposableBag)
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_fetchInvalidRequest() {
        let expectation = XCTestExpectation(description: "Should not fullfil expectation")
        expectation.isInverted = true
        adapter = EmojiAdapter(service: GithubServiceMock<[String: String]>(mockUrl: .invalidEmojiList))
        sut = ImagesGridViewModel(
            emojisAdapter: EmojiAdapter(),
            avatarsAdapter: AvatarAdapter(),
            gridDataType: .emojis
        )
        
        sut.$data
            .dropFirst()
            .sink { emojis in
                XCTAssertEqual(emojis.count, 0)
                expectation.fulfill()
            }
            .store(in: &disposableBag)
        
        wait(for: [expectation], timeout: 0.1)
    }
}
