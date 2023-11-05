import UIKit

protocol EmojiViewModelInterface: ObservableObject {
    
    var emojiModel: EmojiModel { get set }
    var emojiAdapter: EmojiAdapter { get }
    var state: State { get set }
    var image: UIImage? { get set }
    
    func fetchEmojiImage()
}

class EmojiViewModel: EmojiViewModelInterface {
    
    var emojiModel: EmojiModel
    let emojiAdapter: EmojiAdapter
    @Published var state: State = .idle
    @Published var image: UIImage?
    
    init(emojiModel: EmojiModel, emojiAdapter: EmojiAdapter = EmojiAdapter()) {
        self.emojiModel = emojiModel
        self.emojiAdapter = emojiAdapter
        fetchEmojiImage()
    }
    
    func fetchEmojiImage() {
        state = .loading
        Task {
            do {
                guard let imageData = try await self.emojiAdapter.fetchImage(for: emojiModel), let image = UIImage(data: imageData) else { return }
                await MainActor.run {
                    self.state = .concluded
                    self.image = image
                    Task {
                        emojiModel.imageData = imageData
                    }
                }
            } catch {
                // TODO: - deal with error
            }
        }
    }
}
