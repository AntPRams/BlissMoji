import Foundation
import SwiftUI

protocol MainViewModelInterface: ObservableObject {
    
    var error: Error? { get set }
    var adapter: EmojiAdapter { get }
    var state: ViewState { get set }
    var randomEmoji: EmojiModel? { get set }
    
    func fetchEmojis()
    func fetchRandomEmoji()
}

class MainViewModel: MainViewModelInterface {
    
    let adapter: EmojiAdapter
    @Published var error: Error?
    @Published var randomEmoji: EmojiModel?
    @Published var state: ViewState = .initial
    
    init(adapter: EmojiAdapter = EmojiAdapter()) {
        self.adapter = adapter
    }
    
    func fetchEmojis() {
        state = .loading
        Task {
            do {
                _ = try await adapter.fetchEmojisData()
                await MainActor.run {
                    withAnimation {
                        self.state = .idle
                    }
                }
            } catch {
                await MainActor.run {
                    self.error = error
                }
            }
        }
    }
    
    func fetchRandomEmoji() {
        state = .loading
        Task {
            let randomEmoji = await adapter.fetchRandomEmoji()
            await MainActor.run {
                withAnimation {
                    self.state = .idle
                    self.randomEmoji = randomEmoji
                }
            }
        }
    }
}
