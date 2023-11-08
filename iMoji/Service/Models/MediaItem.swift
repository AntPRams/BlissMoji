import UIKit
import SwiftData

enum ItemType: Int, Codable {
    case emoji = 0
    case avatar = 1
}

@Model
class MediaItem {
    @Attribute(.unique) var name: String
    @Attribute(.unique) var imageUrl: URL
    @Attribute(.externalStorage) var imageData: Data?
    
    var type: Int
    
    var image: UIImage? {
        guard let imageData else { return nil }
        return UIImage(data: imageData)
    }
    
    init(name: String, imageUrl: URL, type: Int) {
        self.name = name
        self.imageUrl = imageUrl
        self.type = type
    }
    
    func setImageData(_ data: Data?) {
        self.imageData = data
    }
}
