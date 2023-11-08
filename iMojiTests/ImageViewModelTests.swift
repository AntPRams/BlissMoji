@testable import iMoji
import XCTest
import Foundation

final class ImageViewModelTests: XCTestCase {
    
    var repository: PersistentDataRepositoryMock!
    var sut: ImageViewModel!
    
    override func setUp() {
        super.setUp()
        setSut()
    }
    
    override func tearDown() {
        sut = nil
        repository = nil
        super.tearDown()
    }
    
    func test_viewState() async throws {
        XCTAssertEqual(sut.viewState, .initial)
        
        sut.fetchImage()
        XCTAssertEqual(sut.viewState, .loading)
        
        try await Task.sleep(nanoseconds: 300_000_000)
        
        XCTAssertEqual(sut.viewState, .idle)
    }
    
    func test_fetchImageWithError() async throws {
        setSut(error: NetworkError.badRequest)
        
        XCTAssertNil(sut.error)
        
        sut.fetchImage()
        
        try await Task.sleep(nanoseconds: 300_000_000)
        
        XCTAssertNotNil(sut.error)
        XCTAssertEqual(sut.error as? NetworkError, .badRequest)
    }
}

private extension ImageViewModelTests {
    
    func setSut(error: Error? = nil) {
        repository = PersistentDataRepositoryMock()
        
        if error != nil {
            repository.error = NetworkError.badRequest
        }
        
        let model = MediaItem(
            name: "some",
            imageUrl: URL(string: "https://www.stub.com")!,
            type: ItemType.emoji.rawValue
        )
        
        sut = ImageViewModel(
            item: model,
            repository: repository,
            shouldFetchImageOnInitialization: false
        )
    }
}
