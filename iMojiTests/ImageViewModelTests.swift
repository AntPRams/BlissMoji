@testable import iMoji
import XCTest
import Foundation
import Combine

final class ImageViewModelTests: XCTestCase {
    
    var adapter: EmojiAdapter!
    var sut: ImageViewModel!
    var disposableBag: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        adapter = EmojiAdapter(service: GithubServiceMock<[String: String]>(mockUrl: .emojiList))
        let model = EmojiModel(
            name: "some",
            imageUrl: URL(string: "https://www.apple.com")!)
        
        sut = ImageViewModel(
            model: model,
            emojiAdapter: adapter
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
        sut.fetchImage()
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
        
        wait(for: [stateExpectation, imageExpectation], timeout: 0.1)
    }
}
