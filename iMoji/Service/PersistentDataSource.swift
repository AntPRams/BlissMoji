import Foundation
import SwiftData

@MainActor
final class PersistentDataSource {
    
    private var modelContainer: ModelContainer
    private var modelContext: ModelContext
    
    static let shared = PersistentDataSource()
    
    private init() {
        let schema = Schema([EmojiModel.self, AvatarModel.self])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: false)
        let container = try! ModelContainer(for: schema, configurations: configuration)
        
        self.modelContainer = container
        self.modelContext = ModelContext(modelContainer)
    }
    
    func fetchEmojisListFromPersistence() -> [EmojiModel] {
        do {
            guard let emojis = try fetchEmojisDataFromContext() else { return [] }
            return emojis
        } catch {
            return []
        }
    }
    
    func fetchAvatarsListFromPresistence(with predicate: Predicate<AvatarModel>? = nil) -> [AvatarModel] {
        do {
            guard let emojis = try fetchAvatarsFromContext() else { return [] }
            return emojis
        } catch {
            return []
        }
    }
    
    func fetchAvatarFromPersistence(with name: String) -> AvatarModel? {
        let predicate = #Predicate<AvatarModel> {
            $0.name == name
        }
        return fetchAvatarsListFromPresistence(with: predicate).first
    }
    
    func getRandomEmoji() -> EmojiModel? {
        fetchEmojisListFromPersistence().randomElement()
    }
    
    func insert(_ list: [EmojiModel]) {
        list.forEach { model in
            modelContext.insert(model)
        }
    }
    
    func insert(_ avatar: AvatarModel) {
        modelContext.insert(avatar)
    }
    
    func save(imageData: Data, into model: EmojiModel) {
        model.setImageData(imageData)
        try? modelContext.save()
    }
    
    func delete(avatar: AvatarModel) {
        modelContext.delete(avatar)
    }
    
    func deleteAllData() {
        try? modelContext.delete(model: EmojiModel.self)
        try? modelContext.delete(model: AvatarModel.self)
    }
}

private extension PersistentDataSource {
    
    func fetchAvatarsFromContext(with predicate: Predicate<AvatarModel>? = nil) throws -> [AvatarModel]? {
        let descriptor = FetchDescriptor<AvatarModel>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.name)]
        )
        let avatars = try modelContext.fetch(descriptor)
        
        return avatars
    }
    
    func fetchEmojisDataFromContext() throws -> [EmojiModel]? {
        let descriptor = FetchDescriptor<EmojiModel>(predicate: nil, sortBy: [SortDescriptor(\.name)])
        let emojis = try modelContext.fetch(descriptor)
        
        return emojis
    }
}
