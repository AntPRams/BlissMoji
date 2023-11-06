import Foundation
import SwiftData

@MainActor
final class EmojisDataSource {
    
    private var modelContainer: ModelContainer
    private var modelContext: ModelContext
    
    static let shared = EmojisDataSource()
    
    private init() {
        let schema = Schema([EmojiModel.self])
        let container = try! ModelContainer(for: schema)
        
        self.modelContainer = container
        self.modelContext = ModelContext(modelContainer)
    }
    
    func getEmojisList() -> [EmojiModel] {
        do {
            guard let emojis = try fetchEmojisDataFromContext() else { return [] }
            return emojis
        } catch {
            return []
        }
    }
    
    func getRandomEmoji() -> EmojiModel? {
        getEmojisList().randomElement()
    }
    
    func insert(_ list: [EmojiModel]) {
        list.forEach { model in
            self.modelContext.insert(model)
        }
    }
    
    func save(imageData: Data, into model: EmojiModel) {
        model.setImageData(imageData)
        try? modelContext.save()
    }
    
    func deleteAllData() {
        try? modelContext.delete(model: EmojiModel.self)
    }
}

private extension EmojisDataSource {
    
    func fetchEmojisDataFromContext(with predicate: Predicate<EmojiModel>? = nil) throws -> [EmojiModel]? {
        let descriptor = FetchDescriptor<EmojiModel>(predicate: predicate, sortBy: [SortDescriptor(\.name)])
        let emojis = try modelContext.fetch(descriptor)
        
        return emojis
    }
}

