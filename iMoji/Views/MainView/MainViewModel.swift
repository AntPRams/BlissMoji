import Foundation
import SwiftUI

protocol MainViewModelInterface: ObservableObject {
    
    var error: Error? { get set }
    var emojiAdapter: EmojiAdapter { get }
    var avatarAdapter: AvatarAdapter { get }
    var state: ViewState { get set }
    var modelToPresent: PersistentModelInterface? { get set }
    
    func fetchEmojis()
    func fetchRandomEmoji()
    func searchUser(with name: String)
}

class MainViewModel: MainViewModelInterface {
    
    let emojiAdapter: EmojiAdapter
    let avatarAdapter: AvatarAdapter
    @Published var error: Error?
    @Published var modelToPresent: PersistentModelInterface?
    @Published var state: ViewState = .initial
    
    init(
        emojiAdapter: EmojiAdapter = EmojiAdapter(),
        avatarAdapter: AvatarAdapter = AvatarAdapter()
    ) {
        self.emojiAdapter = emojiAdapter
        self.avatarAdapter = avatarAdapter
    }
    
    func fetchEmojis() {
        state = .loading
        Task {
            do {
                _ = try await emojiAdapter.fetchEmojisData()
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
            let randomEmoji = await emojiAdapter.fetchRandomEmoji()
            await MainActor.run {
                withAnimation {
                    self.state = .idle
                    self.modelToPresent = randomEmoji
                }
            }
        }
    }
    
    func searchUser(with name: String) {
        state = .loading
        Task {
            do {
                let user = try await avatarAdapter.fetch(user: name)
                await MainActor.run {
                    withAnimation {
                        self.state = .idle
                        self.modelToPresent = user
                    }
                }
            } catch {
                await MainActor.run {
                    self.error = error
                }
            }
        }
    }
}
