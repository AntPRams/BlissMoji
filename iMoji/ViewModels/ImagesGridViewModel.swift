import Foundation

@Observable 
class ImagesGridViewModel {
    
    // MARK: - Properties
    
    let repository: PersistentDataRepositoryInterface
    var gridDataType: ItemType
    var data = [MediaItem]()
    var viewState: ViewState = .initial
    var error: Error?
    
    // MARK: - Init
    
    init(
        repository: PersistentDataRepositoryInterface = PersistentDataRepository(),
        gridDataType: ItemType
    ) {
        self.repository = repository
        self.gridDataType = gridDataType
    }
    
    // MARK: - Public Interface
    
    func fetchData() {
        Task { [weak self] in
            guard let self else { return }
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

            Task { [weak self] in
                guard let self else { return }
                await self.repository.removeUser(with: model)
            }
            fallthrough
        case .emoji:
            data.remove(at: index)
        }
    }
}

// MARK: - Private work

private extension ImagesGridViewModel {
    func postAvatarRemovalNotification(_ avatarName: String) {
        NotificationCenter.default.post(
            name: .didRemoveAvatarFromPersistence,
            object: avatarName
        )
    }
}
