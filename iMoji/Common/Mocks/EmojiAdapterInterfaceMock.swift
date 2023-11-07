import Foundation

final class EmojiAdapterMock: EmojiAdapterInterface {
    let service: any Service
    
    init(service: any Service = GithubService<[String: String]>()) {
        self.service = service
    }
    
    func fetchEmojisData() async throws -> [EmojiModel] { [] }
    
    func fetchRandomEmoji() async -> EmojiModel? { nil }
    
    func fetchImage(for emoji: EmojiModel) async throws -> Data { Data() }
}
