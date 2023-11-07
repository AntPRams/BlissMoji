import Foundation

protocol EmojiAdapterInterface: AnyObject {
    init(service: any Service)
    
    func fetchEmojisData() async throws -> [EmojiModel]
    func fetchRandomEmoji() async -> EmojiModel?
    func fetchImage(for emoji: EmojiModel) async throws -> Data
}
