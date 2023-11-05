import Foundation

final class EmojiAdapter {
    
    private let service: GithubService<[String: String]>
    
    init(
        service: GithubService<[String: String]> = GithubService<[String: String]>()
    ) {
        self.service = service
    }
    
    func fetchEmojisData() async throws -> [EmojiModel] {
        let data = try await service.fetchData(from: .emojis)
        
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
        guard let imageData = try await fetchImage(from: emoji.imageUrl) else {
            // TODO: Should return a proper error
            throw NetworkError.badRequest
        }
        return imageData
    }
}

private extension EmojiAdapter {
    
    func fetchImage(from url: URL) async throws -> Data? {
        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
}
