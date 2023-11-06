import UIKit

protocol EmojiViewModelInterface: ObservableObject {
    
    var emojiModel: EmojiModel { get set }
    var adapter: EmojiAdapter { get }
    var state: ViewState { get set }
    var image: UIImage? { get set }
    
    func fetchEmojiImage()
}

class EmojiViewModel: EmojiViewModelInterface {
    
    var emojiModel: EmojiModel
    let adapter: EmojiAdapter
    @Published var state: ViewState = .initial
    @Published var image: UIImage?
    
    init(emojiModel: EmojiModel, adapter: EmojiAdapter = EmojiAdapter(), shouldFetchImageOnInitialization: Bool = true) {
        self.emojiModel = emojiModel
        self.adapter = adapter
        guard shouldFetchImageOnInitialization else { return }
        fetchEmojiImage()
    }
    
    func fetchEmojiImage() {
        guard 
            let imageData = emojiModel.imageData,
            let image = UIImage(data: imageData)
        else {
            state = .loading
            Task {
                do {
                    let imageData = try await self.adapter.fetchImage(for: emojiModel)
                    guard let image = UIImage(data: imageData) else { return }
                    await MainActor.run {
                        self.state = .idle
                        self.image = image
                        Task {
                            emojiModel.imageData = imageData
                        }
                    }
                } catch {
                    // TODO: - deal with error
                }
            }
            return
        }
        self.image = image
    }
}
