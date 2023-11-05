import UIKit

struct EmojiModel: Hashable {
    let id = UUID()
    var name: String
    var imageUrl: URL
    var imageData: Data?
    
    var hasCachedImage: Bool {
        imageData != nil
    }
    
    init(name: String, imageUrl: URL) {
        self.name = name
        self.imageUrl = imageUrl
    }
    
    static func == (lhs: EmojiModel, rhs: EmojiModel) -> Bool {
        lhs.id == rhs.id
    }
}
