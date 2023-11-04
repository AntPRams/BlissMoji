import UIKit
import SwiftData

@Model
class EmojiModel {
    var name: String
    var imageUrl: URL
    @Attribute(.externalStorage) var imageData: Data?
    
    var hasCachedImage: Bool {
        imageData == nil
    }
    
    var emojiImage: UIImage? {
        guard let imageData else {
            return nil
        }
        return UIImage(data: imageData)
    }
    
    init(name: String, imageUrl: URL) {
        self.name = name
        self.imageUrl = imageUrl
    }
}
