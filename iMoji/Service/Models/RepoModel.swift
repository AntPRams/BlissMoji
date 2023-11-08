import Foundation

/// A model structure for parsing github user repo from a network response.
struct RepoModel: Decodable {
    
    let id: Int?
    let name: String?
}
