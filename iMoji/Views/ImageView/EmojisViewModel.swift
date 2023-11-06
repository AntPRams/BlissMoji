import UIKit

protocol ImageViewModelInterface: ObservableObject {
    
    var error: Error? { get set }
    var model: PersistentModelRepresentable { get set }
    var avatarAdapter: AvatarAdapter { get }
    var state: ViewState { get set }
    var image: UIImage? { get set }
    
    func fetchImage()
}

class ImageViewModel: ImageViewModelInterface {
    
    let emojiAdapter: EmojiAdapter
    let avatarAdapter: AvatarAdapter
    @Published var model: PersistentModelRepresentable
    @Published var error: Error?
    @Published var state: ViewState = .initial
    @Published var image: UIImage?
    
    init(
        model: PersistentModelRepresentable,
        emojiAdapter: EmojiAdapter = EmojiAdapter(),
        avatarAdapter: AvatarAdapter = AvatarAdapter(),
        shouldFetchImageOnInitialization: Bool = true
    ) {
        self.model = model
        self.emojiAdapter = emojiAdapter
        self.avatarAdapter = avatarAdapter
        guard shouldFetchImageOnInitialization else { return }
        fetchImage()
    }
    
    func fetchImage() {
        guard let image = model.image else {
            state = .loading
            Task {
                do {
                    let imageData = try await self.fetchImage(for: model)
                    guard let data = imageData else { return }

                    model.imageData = imageData
                    
                    await MainActor.run {
                        self.state = .idle
                        self.image = model.image
                        self.error = NetworkError.badRequest
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
