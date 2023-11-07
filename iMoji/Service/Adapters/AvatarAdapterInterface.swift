import Foundation

protocol AvatarAdapterInterface {
    init(service: any Service, dataSource: PersistentDataSource)
    
    func fetchUsersPreviouslySearched() async throws -> [AvatarModel]
    func fetch(user name: String) async throws -> AvatarModel
    func fetchImage(for avatar: AvatarModel) async throws -> Data
    func removeUser(with model: AvatarModel) async
}
