import Foundation

protocol EmojiAdapterInterface {
    init(service: any Service)
    
    func fetchEmojisData() async throws -> [EmojiModel]
    func fetchRandomEmoji() async throws -> EmojiModel
    func fetchImage(for emoji: EmojiModel) async throws -> Data?
}

final class EmojiAdapter: EmojiAdapterInterface {
    
    private let service: any Service
    
    init(service: any Service = GithubService<[String: String]>()) {
        self.service = service
    }
    
    func fetchEmojisData() async throws -> [EmojiModel] {
        guard let data = try await service.fetchData(from: .emojis) as? [String: String] else {
            return []
        }
        
        let list = data.compactMap { (key: String, value: String) -> EmojiModel? in
            guard let url = URL(string: value) else {
                return nil
            }
            let model = EmojiModel(name: key, imageUrl: url)
            DispatchQueue.main.async {
            }
            return model
        }
        return list
    }
    
    func fetchRandomEmoji() async throws -> EmojiModel {
        guard let emoji = try await fetchEmojisData().randomElement() else {
            // TODO: Should return a proper error
            throw NetworkError.badRequest
        }
        return emoji
    }
    
    func fetchImage(for emoji: EmojiModel) async throws -> Data? {
        try await service.fetchImage(from: emoji.imageUrl)
    }
}
