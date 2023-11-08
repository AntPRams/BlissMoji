import Foundation

/// A protocol defining methods for interacting with persistent data for both avatars and emojis.
protocol PersistentDataRepositoryInterface: AnyObject {
    
    /// Initializes a data repository with the provided services.
    ///
    /// - Parameters:
    ///   - avatarsService: A network service for avatar data.
    ///   - emojisService: A networks ervice for emoji data.
    init(avatarsService: any Service, emojisService: any Service)
    
    /// Asynchronously fetches media items of a specific type.
    ///
    /// - Parameters:
    ///   - type: The type of media items to fetch (eg: avatars or emojis).
    /// - Returns: An array of `MediaItem` models matching the specified type.
    /// - Throws: An error if the fetch operation fails.
    @discardableResult
    func fetchItems(_ type: ItemType) async throws -> [MediaItem]
    
    /// Asynchronously fetches an avatar item for a specific user by name.
    ///
    /// - Parameters:
    ///   - name: The name of the user for whom to fetch the avatar.
    /// - Returns: A `MediaItem` representing the user's avatar.
    /// - Throws: An error if the fetch opeation fails.
    func fetchAvatar(user name: String) async throws -> MediaItem
    
    /// Asynchronously fetches a random emoji media item.
    ///
    /// - Returns: A random `MediaItem` representing an emoji, or `nil` if none are available.
    /// - Throws: An error if the fetch operation encounters an issue.
    func fetchRandomEmoji() async throws -> MediaItem?
    
    /// Asynchronously fetches image data from a specified URL.
    ///
    /// - Parameters:
    ///   - item: The `MediaItem` to which the image should be fetched
    /// - Returns: Data representing the image from the specified URL.
    /// - Throws: An error if the fetch operation fails.
    func fetchImage(for item: MediaItem) async throws -> Data
    
    /// Removes a user and their associated media item from the persistent storage context.
    ///
    /// - Parameters:
    ///   - item: The `MediaItem` associated with the user to be removed.
    func removeUser(with item: MediaItem) async
    
    /// Clear all persisted data from the persistent storage context.
    func deleteAllData() async
}
