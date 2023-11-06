import Foundation
import SwiftData

/// A protocol for defining a common interface for persistent models.
///
/// Conforming to this protocol allows consistent handling of different types of persistent models in the app. It includes properties and a method related to persistent models.
///
/// To conform to this protocol, a class must implement the properties and methods defined here.
///
/// - SeeAlso: `AvatarModel` and  `EmojiModel` for a sample implementation of this protocol.
protocol PersistentModelInterface: AnyObject {
    /// The name of the persistent model.
    var name: String { get set }
    
    /// The URL associated with the persistent model.
    var imageUrl: URL { get set }
    
    /// Optional image data for the persistent model.
    var imageData: Data? { get set }
    
    /// Set the image data for the persistent model.
    ///
    /// - Parameter data: The image data to be associated with the model. Pass `nil` if no image data is available.
    func setImageData(_ data: Data?)
}
