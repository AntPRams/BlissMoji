@testable import iMoji
import XCTest
import Foundation

final class GithubServiceMock<Model: Decodable>: Service {
    typealias DataType = Model
    
    private var apiClient: APIClientInterface
    var mockUrl: MockDataFile
    
    var shouldTryFulfillExpectation: Bool = false
    
    let imageRequestExpectation = XCTestExpectation(description: "Did request image")
    let networkRequestExpectation = XCTestExpectation(description: "Network request expectation")
    
    init(apiClient: APIClientInterface = APIClient(), mockUrl: MockDataFile) {
        self.apiClient = apiClient
        self.mockUrl = mockUrl
    }
    
    func fetchData(from endPoint: iMoji.EndPoint) async throws -> Model {
        if shouldTryFulfillExpectation {
            networkRequestExpectation.fulfill()
        }
        guard let url = URLMocks.getMockDataUrl(for: mockUrl) else {
            throw NetworkError.unknown
        }
        
        let data: Model? = try await apiClient.fetch(from: url)
        
        guard let resultData = data else {
            throw NetworkError.noData
        }
        
        return resultData
    }
    
    func fetchImage(from url: URL) async throws -> Data {
        if url.absoluteString == "https://www.error.com" {
            throw NetworkError.noData
        } else {
            imageRequestExpectation.fulfill()
            let mockImageData = UIImage(systemName: "photo")
            //The force unwrapping was set on purpose since we are on a test context
            let data = mockImageData!.pngData()!
            return data
        }
    }
}
