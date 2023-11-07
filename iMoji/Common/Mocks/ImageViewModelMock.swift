import UIKit

class ImageViewModelMock: ImageViewModelInterface {
    let emojiAdapter: EmojiAdapterInterface
    let avatarAdapter: AvatarAdapterInterface
    @Published var model: PersistentModelRepresentable
    @Published var error: Error?
    @Published var state: ViewState = .initial
    @Published var image: UIImage?
    
    init(
        emojiAdapter: EmojiAdapterInterface = EmojiAdapterMock(),
        avatarAdapter: AvatarAdapterInterface = AvatarAdapterMock(),
        model: PersistentModelRepresentable,
        error: Error? = nil,
        image: UIImage? = nil
    ) {
        self.emojiAdapter = emojiAdapter
        self.avatarAdapter = avatarAdapter
        self.model = model
        fetchImage()
    }
    
    func fetchImage() {
        image = UIImage(systemName: "sun.haze.fill")
    }
}
