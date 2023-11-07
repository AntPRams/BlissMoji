import Foundation
import SwiftData

@MainActor
final class PersistentDataSource {
    
    private var modelContainer: ModelContainer
    private var modelContext: ModelContext
    
    static let shared = PersistentDataSource()
    
    private init() {
        let container = try! ModelContainer(for: MediaItem.self)
        
        self.modelContainer = container
        self.modelContext = ModelContext(modelContainer)
    }
    
    func fetchItems(with predicate: Predicate<MediaItem>? = nil) -> [MediaItem] {
        let descriptor = FetchDescriptor<MediaItem>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.name)]
        )
        guard let items = try? modelContext.fetch(descriptor) else { return [] }
        return items
    }
    
    func insert(_ items: [MediaItem]) {
        items.forEach { model in
            modelContext.insert(model)
        }
    }
    
    func insert(_ item: MediaItem) {
        modelContext.insert(item)
    }
    
    func delete(_ item: MediaItem) {
        modelContext.delete(item)
    }
    
    func deleteAllData() {
        try? modelContext.delete(model: MediaItem.self)
    }
}

//
//func fetchEmojisListFromPersistence() -> [MediaItem] {
//    guard let emojis = try? fetchModelFromContext(sortDescriptor: [SortDescriptor(\EmojiModel.name)]) else { return [] }
//    return emojis
//}
//
//func fetchAvatarsListFromPresistence(with predicate: Predicate<AvatarModel>? = nil) -> [AvatarModel] {
//    guard let avatars = try? fetchModelFromContext(
//        with: predicate,
//        sortDescriptor: [SortDescriptor(\.name)]
//    ) else { return [] }
//    
//    return avatars
//}
//
//func fetchAvatarFromPersistence(with name: String) -> AvatarModel? {
//    let predicate = #Predicate<AvatarModel> {
//        $0.name.localizedStandardContains(name)
//    }
//    return fetchAvatarsListFromPresistence(with: predicate).first
//}
//
//func getRandomEmoji() -> EmojiModel? {
//    fetchEmojisListFromPersistence().randomElement()
//}
//
//func insert(_ list: [EmojiModel]) {
//    list.forEach { model in
//        modelContext.insert(model)
//    }
//}
//
//func insert(_ avatar: AvatarModel) {
//    modelContext.insert(avatar)
//}
//
//func delete(avatar: AvatarModel) {
//    modelContext.delete(avatar)
//}
//
//func deleteAllData() {
//    try? modelContext.delete(model: EmojiModel.self)
//    try? modelContext.delete(model: AvatarModel.self)
//}
