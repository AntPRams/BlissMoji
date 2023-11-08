import Foundation
import SwiftData

/// A class that serves as a data source for managing and persisting `MediaItem` models (emojis and avatars).
///
/// `PersistentDataSource` provides methods for fetching, inserting, and deleting `MediaItem` models in a persistent storage context,.
@MainActor
final class PersistentDataSource {
    
    // MARK: - Properties
    
    private var modelContainer: ModelContainer
    private var modelContext: ModelContext
    
    static let shared = PersistentDataSource()
    
    // MARK: - Init
    
    private init() {
        let container = try! ModelContainer(for: MediaItem.self)
        
        self.modelContainer = container
        self.modelContext = ModelContext(modelContainer)
    }
    
    // MARK: - Public interface
    
    /// Fetches `MediaItem` models from context.
    ///
    /// - Parameters:
    ///   - predicate: An optional predicate to filter the results. Default value is `nil`.
    /// - Returns: An array of `MediaItem` models that match the given predicate.
    func fetchItems(with predicate: Predicate<MediaItem>? = nil) -> [MediaItem] {
        let descriptor = FetchDescriptor<MediaItem>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.name)]
        )
        guard let items = try? modelContext.fetch(descriptor) else { return [] }
        return items
    }
    
    /// Inserts an array of `MediaItem` models into he persistent storage context.
    ///
    /// - Parameter items: An array of `MediaItem` models to insert.
    func insert(_ items: [MediaItem]) {
        items.forEach { model in
            modelContext.insert(model)
        }
    }
    
    /// Inserts a `MediaItem` model into the persistent storage context.
    ///
    /// - Parameter item: The `MediaItem` model to insert.
    func insert(_ item: MediaItem) {
        modelContext.insert(item)
    }
    
    /// Deletes a `MediaItem` model into from the persistent storage context.
    ///
    /// - Parameter item: The `MediaItem` model to insert.
    func delete(_ item: MediaItem) {
        modelContext.delete(item)
    }
    
    /// Deletes all `MediaItem` models from the persistent storage context.
    func deleteAll() {
        try? modelContext.delete(model: MediaItem.self)
    }
}
