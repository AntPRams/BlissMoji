import UIKit

class PersistentModelMock: PersistentModelRepresentable {
    var name: String
    var imageUrl: URL
    var imageData: Data?
    var image: UIImage?
    
    init(
        name: String = "Image view",
        imageUrl: URL = URL(string: "")!,
        imageData: Data? = nil,
        image: UIImage? = nil
    ) {
        self.name = name
        self.imageUrl = imageUrl
        self.imageData = imageData
        self.image = image
    }
    
    func setImageData(_ data: Data?) { }
    
}
