import Foundation

class ImagesGridViewModel: ObservableObject {
    
    let repository: PersistentDataRepository
    var gridDataType: ItemType
    
    @Published var error: Error?
    @Published var data = [MediaItem]()
    
    init(
        repository: PersistentDataRepository = PersistentDataRepository(),
        gridDataType: ItemType
    ) {
        self.repository = repository
        self.gridDataType = gridDataType
    }
    
    func fetchData() {
        Task {
            do {
                let items = try await repository.fetchItems(gridDataType)
                await MainActor.run {
                    self.data = items
                }
            } catch {
                await MainActor.run {
                    self.error = error
                }
            }
        }
    }
    
    func removeElement(at index: Int) {
        switch gridDataType {
        case .avatar:
            guard let model = data[safe: index] else {
                fallthrough
            }
            postAvatarRemovalNotification(model.name)

            Task {
                await repository.removeUser(with: model)
            }
            fallthrough
        case .emoji:
            data.remove(at: index)
        }
    }
}

private extension ImagesGridViewModel {
    func postAvatarRemovalNotification(_ avatarName: String) {
        NotificationCenter.default.post(
            name: .didRemoveAvatarFromPersistence,
            object: avatarName
        )
    }
}
