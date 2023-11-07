import Foundation

protocol AvatarAdapterInterface: AnyObject {
    init(service: any Service)
    
    func fetchUsersPreviouslySearched() async throws -> [AvatarModel]
    func fetch(user name: String) async throws -> AvatarModel
    func fetchImage(for avatar: AvatarModel) async throws -> Data
    func removeUser(with model: AvatarModel) async
}
