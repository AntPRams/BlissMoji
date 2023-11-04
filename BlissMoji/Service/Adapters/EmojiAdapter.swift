import Foundation
import SwiftUI
import SwiftData

class EmojiAdapter {
    
    private let service: GithubService<[String: String]>
    private let modelContext: ModelContext
    
    init(
        service: GithubService<[String: String]> = GithubService<[String: String]>(),
        modelContext: ModelContext
    ) {
        self.service = service
        self.modelContext = modelContext
    }
    
    func fetchEmojisData() async throws -> [EmojiModel] {
        guard let emojisList = try fetchEmojisDataFromContext(), emojisList.isNotEmpty else {
            let data = try await service.fetchData(from: .emojis)
            
            let emojis = data.compactMap { (key: String, value: String) -> EmojiModel? in
                guard let url = URL(string: value) else {
                    return nil
                }
                let model = EmojiModel(name: key, imageUrl: url)
                modelContext.insert(model)
                return model
            }
            return emojis
        }
        return emojisList
    }
    
    func fetchImage(with name: String) async throws -> UIImage? {
        let predicate = #Predicate<EmojiModel> { emoji in
            emoji.name == name
        }
        let emojis = try fetchEmojisDataFromContext(with: predicate)
        
        guard let emojis, let emoji = emojis.first else {
            // TODO: Should return error stating that image couldnt be found
            return nil
        }
        
        guard let image = emoji.image else {
            if let imageData = try await fetchImage(from: emoji.imageUrl) {
                emoji.imageData = imageData
                return UIImage(data: imageData)
            }
            // TODO: Should return error stating that image couldnt be parsed (!?)
            return nil
        }
        return image
    }
}

private extension EmojiAdapter {
    
    func fetchEmojisDataFromContext(with predicate: Predicate<EmojiModel>? = nil) throws -> [EmojiModel]? {
        let descriptor = FetchDescriptor<EmojiModel>(predicate: predicate, sortBy: [SortDescriptor(\.name)])
        let emojis = try modelContext.fetch(descriptor)
        
        return emojis
    }
    
    func fetchImage(from url: URL) async throws -> Data? {
        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
}
