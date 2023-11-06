import Foundation

final class AvatarAdapter: AvatarAdapterInterface {
    
    // MARK: - Properties
    
    private let service: any Service
    
    // MARK: - Init
    
    init(service: any Service = GithubService<AvatarNetworkModel>()) {
        self.service = service
    }
    
    // MARK: - Public interface
    
    func fetchUsersPreviouslySearched() async throws -> [AvatarModel] {
        return []
    }
    
    func fetch(user name: String) async throws -> AvatarModel {
        guard let user = try await service.fetchData(from: .avatar(user: name)) as? AvatarNetworkModel else {
            // TODO: - Add a error to validade a requets with no results
            throw NetworkError.badRequest
        }
        
        guard let userName = user.name, let avatarUrl = user.avatarUrl, let url = URL(string: avatarUrl) else {
            // TODO: - Add a error to validade a requets with no results or a better method to unwrap
            throw NetworkError.badRequest
        }
        
        let model = AvatarModel(name: userName, imageUrl: url)
        
        return model
    }
    
    func fetchImage(for avatar: AvatarModel) async throws -> Data {
        try await service.fetchImage(from: avatar.imageUrl)
    }
}
