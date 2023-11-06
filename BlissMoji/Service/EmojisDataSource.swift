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
        print("getEmojisList isMain: \(Thread.current.isMainThread)")
        do {
            guard let emojis = try fetchEmojisDataFromContext() else { return [] }
            return emojis
        } catch {
            print("BOING")
            return []
        }
    }
    
    func getRandomEmoji() -> EmojiModel? {
        getEmojisList().randomElement()
    }
    
    func insert(_ list: [EmojiModel]) {
        print("insert isMain: \(Thread.current.isMainThread)")
        list.forEach { model in
            self.modelContext.insert(model)
        }
    }
    
    func save(imageData: Data, into model: EmojiModel) {
        print("save image data isMain: \(Thread.current.isMainThread)")
        model.setImageData(imageData)
        try? modelContext.save()
    }
}

private extension EmojisDataSource {
    
    func fetchEmojisDataFromContext(with predicate: Predicate<EmojiModel>? = nil) throws -> [EmojiModel]? {
        print("fetchEmojisDataFromContext isMain: \(Thread.current.isMainThread)")
        let descriptor = FetchDescriptor<EmojiModel>(predicate: predicate, sortBy: [SortDescriptor(\.name)])
        let emojis = try modelContext.fetch(descriptor)
        
        return emojis
    }
}

