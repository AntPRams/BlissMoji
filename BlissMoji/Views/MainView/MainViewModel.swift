import Foundation

protocol MainViewModelInterface: ObservableObject {
    
    var adapter: EmojiAdapter { get }
    var state: ViewState { get set }
    var randomEmoji: EmojiModel? { get set }
    
    func fetchEmojis()
    func fetchRandomEmoji()
}

class MainViewModel: MainViewModelInterface {
    
    let adapter: EmojiAdapter
    @Published var randomEmoji: EmojiModel?
    @Published var state: ViewState = .initial
    
    init(adapter: EmojiAdapter = EmojiAdapter()) {
        self.adapter = adapter
        fetchEmojis()
    }
    
    func fetchEmojis() {
        state = .loading
        Task {
            do {
                _ = try await adapter.fetchEmojisData()
                await MainActor.run {
                    self.state = .idle
                }
            } catch {
                //TODO: - deal with this
            }
        }
    }
    
    func fetchRandomEmoji() {
        state = .loading
        Task {
            do {
                let randomEmoji = try await adapter.fetchRandomEmoji()
                await MainActor.run {
                    self.state = .idle
                    self.randomEmoji = randomEmoji
                }
            } catch {
                // TODO: - Deal with error
            }
        }
    }
}
