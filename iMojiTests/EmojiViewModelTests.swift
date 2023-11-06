@testable import iMoji
import XCTest
import Foundation
import Combine

final class EmojiViewModelTests: XCTestCase {
    
    var adapter: EmojiAdapter!
    var sut: EmojiViewModel!
    var disposableBag: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        adapter = EmojiAdapter(service: GithubServiceMock<[String: String]>(mockUrl: .emojiList))
        sut = EmojiViewModel(
            emojiModel: EmojiModel(
                name: "some",
                imageUrl: URL(string: "https://www.apple.com")!),
            adapter: adapter,
            shouldFetchImageOnInitialization: false
        )
        disposableBag = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        sut = nil
        adapter = nil
        disposableBag = nil
        super.tearDown()
    }
    
    func test_fetchImage() {
        sut.fetchEmojiImage()
        let stateExpectation = XCTestExpectation(description: "Did set state")
        let imageExpectation = XCTestExpectation(description: "Did receive image")
        
        sut.$state
            .dropFirst() //Dropping the initial value
            .sink { state in
                XCTAssertEqual(state, .idle)
                stateExpectation.fulfill()
            }
            .store(in: &disposableBag)
        
        sut.$image
            .dropFirst() //Dropping the initial value
            .sink { image in
                guard let _ = image else {
                    XCTFail("Should have received an image")
                    return
                }
                imageExpectation.fulfill()
            }
            .store(in: &disposableBag)
        
        wait(for: [stateExpectation, imageExpectation], timeout: 0.3)
    }
}
