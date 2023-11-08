@testable import iMoji
import Foundation

final class PersistentDataRepositoryMock: PersistentDataRepositoryInterface {
    
    // MARK: - Properties
    
    private let avatarsService: any Service
    private let emojisService: any Service
    var error: Error?
    
    // MARK: - Init
    
    init(
        avatarsService: any Service = GithubService<AvatarModel>(),
        emojisService: any Service = GithubService<[String: String]>()
    ) {
        self.avatarsService = avatarsService
        self.emojisService = emojisService
    }
    
    func fetchItems(_ type: iMoji.ItemType) async throws -> [iMoji.MediaItem] {
        guard let error else { return [] }
        throw error
    }
    
    func fetchAvatar(user name: String) async throws -> iMoji.MediaItem {
        .init(
            name: "avatar-stub",
            imageUrl: URL(string: "stub")!,
            type: ItemType.avatar.rawValue
        )
    }
    
    func fetchRandomEmoji() async throws -> iMoji.MediaItem? {
        .init(
            name: "emoji-stub",
            imageUrl: URL(string: "stub")!,
            type: ItemType.emoji.rawValue
        )
    }
    
    func fetchImage(for item: iMoji.MediaItem) async throws -> Data {
        guard let error else { return Data() }
        throw error
    }
    
    func removeUser(with item: iMoji.MediaItem) async { }
    
    func deleteAllData() async { }
}
