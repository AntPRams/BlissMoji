import Foundation

protocol AvatarAdapterInterface {
    init(service: any Service)
    
    func fetch(user name: String) async throws -> AvatarModel
    func fetchImage(for avatar: AvatarModel) async throws -> Data
}
