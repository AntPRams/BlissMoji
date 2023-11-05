import Foundation

protocol EmojisListViewModelInterface: ObservableObject {
    
    var emojiAdapter: EmojiAdapter { get }
    var emojis: [EmojiModel] { get set }
    
    func fetchEmojis()
}

class EmojisListViewModel: EmojisListViewModelInterface {
    
    let emojiAdapter: EmojiAdapter
    
    @Published var emojis = [EmojiModel]()
    
    init(emojiAdapter: EmojiAdapter = EmojiAdapter()) {
        self.emojiAdapter = emojiAdapter
        fetchEmojis()
    }
    
    func fetchEmojis() {
        Task {
            do {
                let emojis = try await emojiAdapter.fetchEmojisData()
                await MainActor.run {
                    self.emojis = emojis
                }
            } catch {
                await MainActor.run {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
