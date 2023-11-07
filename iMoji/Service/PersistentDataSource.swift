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
        guard let emojis = try? fetchModelFromContext(sortDescriptor: [SortDescriptor(\EmojiModel.name)]) else { return [] }
        return emojis
    }
    
    func fetchAvatarsListFromPresistence(with predicate: Predicate<AvatarModel>? = nil) -> [AvatarModel] {
        guard let avatars = try? fetchModelFromContext(
            with: predicate,
            sortDescriptor: [SortDescriptor(\.name)]
        ) else { return [] }
        
        return avatars
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
    
    func fetchModelFromContext<T: PersistentModel>(
        with predicate: Predicate<T>? = nil,
        sortDescriptor: [SortDescriptor<T>]
    ) throws -> [T]?
    {
        let descriptor = FetchDescriptor<T>(
            predicate: predicate,
            sortBy: sortDescriptor
        )
        let models = try modelContext.fetch(descriptor)
        
        return models
    }
}
