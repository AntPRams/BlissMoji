import Foundation

final class URLMocks {
    class func getMockDataUrl(for type: MockDataFile) -> URL? {
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
    case validUserData
    case invalidUserData
    case validReposList
    case validEmptyReposList
}
