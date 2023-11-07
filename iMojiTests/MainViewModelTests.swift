@testable import iMoji
import XCTest
import Foundation
import Combine

final class MainViewModelTests: XCTestCase {
    
    var adapter: EmojiAdapter!
    var sut: MainViewModel!
    var disposableBag: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        adapter = EmojiAdapter(service: GithubServiceMock<[String: String]>(mockUrl: .emojiList))
        sut = MainViewModel(emojiAdapter: EmojiAdapter(), avatarAdapter: AvatarAdapter())
        disposableBag = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        sut = nil
        adapter = nil
        disposableBag = nil
        super.tearDown()
    }
    
    func test_fetchRandomEmoji() {
        sut.fetchRandomEmoji()
        let stateExpectation = XCTestExpectation(description: "Did set state")
        let randomEmojiExpectation = XCTestExpectation(description: "Did receive emoji")
        
        sut.$state
            .dropFirst() //Dropping the initial value
            .sink { state in
                XCTAssertEqual(state, .idle)
                stateExpectation.fulfill()
            }
            .store(in: &disposableBag)
        
        sut.$modelToPresent
            .dropFirst() //Dropping the initial value
            .sink { emoji in
                guard let emoji else {
                    XCTFail("Should have received an emoji")
                    return
                }
                randomEmojiExpectation.fulfill()
            }
            .store(in: &disposableBag)
        
        wait(for: [stateExpectation, randomEmojiExpectation], timeout: 0.1)
    }
}
