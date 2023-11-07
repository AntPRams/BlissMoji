import UIKit

class ImageViewModelMock: ImageViewModelInterface {
    let emojiAdapter: EmojiAdapter
    let avatarAdapter: AvatarAdapter
    @Published var model: PersistentModelRepresentable
    @Published var error: Error?
    @Published var state: ViewState = .initial
    @Published var image: UIImage?
    
    init(
        emojiAdapter: EmojiAdapter = EmojiAdapter(),
        avatarAdapter: AvatarAdapter = AvatarAdapter(),
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
