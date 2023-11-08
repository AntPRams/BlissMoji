import Foundation

/// A model structure for parsing github user data from a network response.
struct AvatarModel: Decodable {
    
    let id: Int?
    let name: String?
    let avatarUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "login"
        case avatarUrl = "avatar_url"
    }
}
