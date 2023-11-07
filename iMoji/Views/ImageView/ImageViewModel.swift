import UIKit

protocol ImageViewModelInterface: ObservableObject {
    
    var error: Error? { get set }
    var model: PersistentModelRepresentable { get set }
    var avatarAdapter: AvatarAdapterInterface { get }
    var emojiAdapter: EmojiAdapterInterface { get }
    var state: ViewState { get set }
    var image: UIImage? { get set }
    
    func fetchImage()
}

class ImageViewModel: ImageViewModelInterface {
    
    let emojiAdapter: EmojiAdapterInterface
    let avatarAdapter: AvatarAdapterInterface
    @Published var model: PersistentModelRepresentable
    @Published var error: Error?
    @Published var state: ViewState = .initial
    @Published var image: UIImage?
    
    init(
        model: PersistentModelRepresentable,
        emojiAdapter: EmojiAdapterInterface = EmojiAdapter(),
        avatarAdapter: AvatarAdapterInterface = AvatarAdapter(),
        shouldFetchImageOnInitialization: Bool = true
    ) {
        self.model = model
        self.emojiAdapter = emojiAdapter
        self.avatarAdapter = avatarAdapter
        guard shouldFetchImageOnInitialization, image == nil else { return }
        fetchImage()
    }
    
    func fetchImage() {
        guard let image = model.image else {
            state = .loading
            Task {
                do {
                    let imageData = try await self.fetchImage(for: model)
                    
                    await MainActor.run {
                        model.imageData = imageData
                        self.state = .idle
                        self.image = model.image
                    }
                } catch {
                    await MainActor.run {
                        self.state = .idle
                    }
                }
            }
            return
        }
        self.image = image
    }
    
    func fetchImage(for persistentModel: PersistentModelRepresentable) async throws -> Data? {
        if let emojiModel = persistentModel as? EmojiModel {
            return try await self.emojiAdapter.fetchImage(for: emojiModel)
        } else if let avatarModel = persistentModel as? AvatarModel {
            return try await self.avatarAdapter.fetchImage(for: avatarModel)
        }
        return nil
    }
}
