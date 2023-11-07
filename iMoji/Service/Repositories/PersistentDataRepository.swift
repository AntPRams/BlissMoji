import Foundation

final class PersistentDataRepository {
    
    // MARK: - Properties
    
    private let avatarsService: any Service
    private let emojisService: any Service
    private let dataSource = PersistentDataSource.shared
    
    // MARK: - Init
    
    init(
        avatarsService: any Service = GithubService<AvatarNetworkModel>(),
        emojisService: any Service = GithubService<[String: String]>()
    ) {
        self.avatarsService = avatarsService
        self.emojisService = emojisService
    }
    
    // MARK: - Public interface
    
    @discardableResult
    func fetchItems(_ type: ItemType) async throws -> [MediaItem] {
        let predicate = #Predicate<MediaItem> {
            type.rawValue == $0.type
        }
        
        let items = await dataSource.fetchItems(with: predicate)
        
        guard type == .avatar || items.isNotEmpty else {
            // TODO: - This method should be improved
            if let data = try await emojisService.fetchData(from: .emojis) as? [String: String] {
                let list = data.compactMap { (key: String, value: String) -> MediaItem? in
                    guard let url = URL(string: value) else {
                        return nil
                    }
                    
                    let model = MediaItem(
                        name: key,
                        imageUrl: url,
                        type: ItemType.emoji.rawValue
                    )
                    
                    return model
                }
                
                await dataSource.insert(list)
                return list
            }
            return []
        }
        return items
    }
    
    func fetchAvatar(user name: String) async throws -> MediaItem {
        let avatarType = ItemType.avatar.rawValue
        let predicate = #Predicate<MediaItem> {
            $0.name.localizedStandardContains(name) && 
            avatarType == $0.type
        }
        
        guard let avatar = await dataSource.fetchItems(with: predicate).first else {
            if let data = try await avatarsService.fetchData(from: .avatar(user: name)) as? AvatarNetworkModel {
                if
                    let name = data.name,
                    let imageUrl = data.avatarUrl,
                    let url = URL(string: imageUrl) 
                {
                    let item = MediaItem(
                        name: name,
                        imageUrl: url,
                        type: ItemType.avatar.rawValue
                    )
                    await dataSource.insert([item])
                    return item
                }
            }
            throw NetworkError.badRequest
        }
        return avatar
    }
    
    func fetchImage(with url: URL) async throws -> Data {
        try await emojisService.fetchImage(from: url)
    }
    
    func removeUser(with item: MediaItem) async {
        await dataSource.delete(item)
    }
}
