import Foundation
import SwiftData

@Model
class EmojiModel {
    @Attribute(.unique) var name: String
    var imageUrl: URL
    @Attribute(.externalStorage) var imageData: Data?
    
    var hasCachedImage: Bool {
        imageData != nil
    }
    
    init(name: String, imageUrl: URL) {
        self.name = name
        self.imageUrl = imageUrl
    }
    
    func setImageData(_ data: Data?) {
        self.imageData = data
    }
}
