import Foundation

final class URLMocks {
        
    private init() {}
    
    static func getMockDataUrl(for type: MockDataFile) -> URL? {
        Bundle(for: URLMocks.self)
            .url(
                forResource: type.rawValue,
                withExtension: "json"
            )
    }
}

enum MockDataFile: String {
    case emojiList
    case invalidEmojiList
}

