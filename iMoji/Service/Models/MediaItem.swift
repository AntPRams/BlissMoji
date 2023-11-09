import UIKit
import SwiftData

/// A model class representing a media item for persistence using SwiftData framework.
@Model
class MediaItem {
    @Attribute(.unique) var modelId: String = UUID().uuidString
    /// The name of the item.
    @Attribute(.unique) var name: String
    /// The URL of the item's image.
    @Attribute(.unique) var imageUrl: URL
    /// The item's image data.
    @Attribute(.externalStorage) var imageData: Data?
    
    /// The type of the media item.
    ///
    /// - Note: Since `SwiftData` does not support `enum`s, this property is being used to differentiate between emojis and avatars using `ItemType`'s raw value.
    var type: Int
    
    var image: UIImage? {
        guard let imageData else { return nil }
        return UIImage(data: imageData)
    }
    
    /// Initializes a new `MediaItem`.
    ///
    /// - Parameters:
    ///   - name: The name of the item.
    ///   - imageUrl: The URL of the item's image.
    ///   - type: The type of the media item.
    init(name: String, imageUrl: URL, type: Int) {
        self.name = name
        self.imageUrl = imageUrl
        self.type = type
    }
    
    func update<T>(keyPath: ReferenceWritableKeyPath<MediaItem, T>, to value: T) {
        self[keyPath: keyPath] = value
    }
}
