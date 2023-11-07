import Foundation

final class AvatarAdapterMock: AvatarAdapterInterface {
    
    let service: any Service
    
    init(service: any Service = GithubService<[String: String]>()) {
        self.service = service
    }
    
    func fetchUsersPreviouslySearched() async throws -> [AvatarModel] { [] }
    
    func fetch(user name: String) async throws -> AvatarModel { AvatarModel(name: "", imageUrl: URL(string: "")!) }
    
    func fetchImage(for avatar: AvatarModel) async throws -> Data { Data() }
    
    func removeUser(with model: AvatarModel) async {}
}
