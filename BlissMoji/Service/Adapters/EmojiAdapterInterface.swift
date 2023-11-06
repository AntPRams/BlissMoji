import Foundation

protocol EmojiAdapterInterface {
    init(service: any Service, dataSource: EmojisDataSource)
    
    func fetchEmojisData() async throws -> [EmojiModel]
    func fetchRandomEmoji() async throws -> EmojiModel
    func fetchImage(for emoji: EmojiModel) async throws -> Data
}
