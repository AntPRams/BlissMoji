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
