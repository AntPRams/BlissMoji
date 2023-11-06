@testable import iMoji
import XCTest
import Foundation
import Combine

final class EmojisListViewModelTests: XCTestCase {
    
    var adapter: EmojiAdapter!
    var sut: EmojisListViewModel!
    var disposableBag: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        adapter = EmojiAdapter(service: GithubServiceMock<[String: String]>(mockUrl: .emojiList))
        sut = EmojisListViewModel(
            adapter: adapter,
            shouldLoadEmojisOnInitialization: false
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
        sut.fetchEmojis()
        
        sut.$emojis
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
        sut = EmojisListViewModel(
            adapter: adapter,
            shouldLoadEmojisOnInitialization: false
        )
        
        sut.$emojis
            .dropFirst()
            .sink { emojis in
                XCTAssertEqual(emojis.count, 0)
                expectation.fulfill()
            }
            .store(in: &disposableBag)
        
        wait(for: [expectation], timeout: 0.1)
    }
}
