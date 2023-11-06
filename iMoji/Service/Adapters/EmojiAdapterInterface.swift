import Foundation

protocol EmojiAdapterInterface {
    init(service: any Service, dataSource: PersistentDataSource)
    
    func fetchEmojisData() async throws -> [EmojiModel]
    func fetchRandomEmoji() async -> EmojiModel?
    func fetchImage(for emoji: EmojiModel) async throws -> Data
}
