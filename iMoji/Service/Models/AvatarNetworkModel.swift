import Foundation

struct AvatarNetworkModel: Decodable {
    
    let id: String?
    let name: String?
    let avatarUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "login"
        case avatarUrl = "avatar_url"
    }
}
