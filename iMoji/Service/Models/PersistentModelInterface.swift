import Foundation

protocol PersistentModelInterface {
    var name: String { get set }
    var imageUrl: URL { get set }
    var imageData: Data? { get set }
    
    func setImageData(_ data: Data?)
}
