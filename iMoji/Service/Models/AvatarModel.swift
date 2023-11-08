import Foundation

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
