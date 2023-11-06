import Foundation

final class EmojiAdapter: EmojiAdapterInterface {
    
    // MARK: - Properties
    
    private let service: any Service
    private let dataSource: PersistentDataSource
    
    // MARK: - Init
    
    init(service: any Service = GithubService<[String: String]>(), dataSource: PersistentDataSource = PersistentDataSource.shared) {
        self.service = service
        self.dataSource = dataSource
    }
    
    // MARK: - Public interface
    
    func fetchEmojisData() async throws -> [EmojiModel] {
        let data = await dataSource.fetchEmojisListFromPersistence()
        
        guard data.isNotEmpty else {
            
            guard let data = try await service.fetchData(from: .emojis) as? [String: String] else {
                return []
            }
            
            let list = data.compactMap { (key: String, value: String) -> EmojiModel? in
                guard let url = URL(string: value) else {
                    return nil
                }
                let model = EmojiModel(name: key, imageUrl: url)
                return model
            }
            await dataSource.insert(list)
            return list
        }
        return data
    }
    
    func fetchRandomEmoji() async -> EmojiModel? {
        await dataSource.getRandomEmoji()
    }
    
    func fetchImage(for emoji: EmojiModel) async throws -> Data {
        try await service.fetchImage(from: emoji.imageUrl)
    }
    
    func deleteAllDataFromPersistence() async {
        await dataSource.deleteAllData()
    }
}
