import Foundation

protocol ImagesGridViewModelInterface: ObservableObject {
    
    var error: Error? { get set }
    var avatarsAdapter: AvatarAdapter { get }
    var emojisAdapter: EmojiAdapter { get }
    var data: [AnyHashable] { get set }
    var gridDataType: GridDataType { get set }
    
    func fetchData()
    func removeElement(at index: Int)
}

enum GridDataType {
    case emojis, avatars
}

class ImagesGridViewModel: ImagesGridViewModelInterface {
    
    let emojisAdapter: EmojiAdapter
    let avatarsAdapter: AvatarAdapter
    var gridDataType: GridDataType
    
    @Published var error: Error?
    @Published var data = [AnyHashable]()
    
    init(
        emojisAdapter: EmojiAdapter = EmojiAdapter(),
        avatarsAdapter: AvatarAdapter = AvatarAdapter(),
        gridDataType: GridDataType
    ) {
        self.emojisAdapter = emojisAdapter
        self.gridDataType = gridDataType
        self.avatarsAdapter = avatarsAdapter
    }
    
    func fetchData() {
        Task {
            do {
                let data: [AnyHashable] = switch gridDataType {
                case .emojis:
                    try await emojisAdapter.fetchEmojisData()
                case .avatars:
                    try await avatarsAdapter.fetchUsersPreviouslySearched()
                }
                await MainActor.run {
                    self.data = data
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
        case .avatars:
            guard let avatarModel = data[index] as? AvatarModel else {
                fallthrough
            }
            postAvatarRemovalNotification(avatarModel.name)

            Task {
                await avatarsAdapter.removeUser(with: avatarModel)
            }
            fallthrough
        case .emojis:
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
