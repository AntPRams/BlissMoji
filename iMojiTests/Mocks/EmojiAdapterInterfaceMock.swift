import Foundation

final class EmojiAdapterMock: EmojiAdapterInterface {
    let service = GithubService<[String: String]>()
    
    init(service: any Service) {}
    
    func fetchEmojisData() async throws -> [EmojiModel] { [] }
    
    func fetchRandomEmoji() async -> EmojiModel? { nil }
    
    func fetchImage(for emoji: EmojiModel) async throws -> Data { Data() }
}
