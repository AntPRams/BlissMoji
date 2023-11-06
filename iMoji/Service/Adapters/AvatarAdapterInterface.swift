import Foundation

protocol AvatarAdapterInterface {
    init(service: any Service)
    
    func fetchUser() async throws -> [AvatarModel]
    func fetchImage(for avatar: AvatarModel) async throws -> Data
}
