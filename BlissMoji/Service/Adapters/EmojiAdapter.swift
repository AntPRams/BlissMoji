import Foundation
import SwiftUI
import SwiftData

class EmojiAdapter {
    
    private let service: GithubService<[String: String]>
    private let modelContext: ModelContext
    
    init(
        service: GithubService<[String : String]> = GithubService<[String : String]>(),
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
    
    private func fetchEmojisDataFromContext() throws -> [EmojiModel]? {
        let descriptor = FetchDescriptor<EmojiModel>(sortBy: [SortDescriptor(\.name)])
        let emojis = try? modelContext.fetch(descriptor)
        
        return emojis
    }
}
