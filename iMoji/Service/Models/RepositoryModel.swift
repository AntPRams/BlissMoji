import Foundation

/// A model structure for parsing github user repo from a network response.
struct RepositoryModel: Decodable {
    
    let id: Int?
    let name: String?
}
