/// An enum representing different typesof items used to differentiate models in `SwiftData` persistence.
enum ItemType: Int, Codable {
    case emoji = 0
    case avatar = 1
}

extension ItemType {
    
    var contentUnavailableDescription: String {
        switch self {
        case .emoji: return Localizable.emojisContentUnavailableDescription
        case .avatar: return Localizable.avatarContentUnavailableDescription
        }
    }
}
