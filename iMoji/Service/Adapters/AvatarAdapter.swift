import Foundation

final class AvatarAdapter: AvatarAdapterInterface {
    
    // MARK: - Properties
    
    private let service: any Service
    private let dataSource: PersistentDataSource
    
    // MARK: - Init
    
    init(service: any Service = GithubService<AvatarNetworkModel>(), dataSource: PersistentDataSource = PersistentDataSource.shared) {
        self.service = service
        self.dataSource = dataSource
    }
    
    // MARK: - Public interface
    
    func fetchUsersPreviouslySearched() async throws -> [AvatarModel] {
        return await dataSource.fetchAvatarsListFromPresistence()
    }
    
    func fetch(user name: String) async throws -> AvatarModel {
        guard let avatar = await dataSource.fetchAvatarFromPersistence(with: name) else {
            guard let user = try await service.fetchData(from: .avatar(user: name)) as? AvatarNetworkModel else {
                // TODO: - Add a error to validade a requets with no results
                throw NetworkError.badRequest
            }
            
            guard let userName = user.name, let avatarUrl = user.avatarUrl, let url = URL(string: avatarUrl) else {
                // TODO: - Add a error to validade a requets with no results or a better method to unwrap
                throw NetworkError.badRequest
            }
            
            let avatar = AvatarModel(name: userName, imageUrl: url)
            await dataSource.insert(avatar)
            
            return avatar
        }
        return avatar
    }
    
    func fetchImage(for avatar: AvatarModel) async throws -> Data {
        try await service.fetchImage(from: avatar.imageUrl)
    }
    
    func removeUser(with model: AvatarModel) async {
        await dataSource.delete(avatar: model)
    }
}
