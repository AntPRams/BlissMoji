import Foundation
import SwiftUI
import Combine

protocol MainViewModelInterface: ObservableObject {
    
    var error: Error? { get set }
    var emojiAdapter: EmojiAdapterInterface { get }
    var avatarAdapter: AvatarAdapterInterface { get }
    var nameQuery: String { get set }
    var state: ViewState { get set }
    var modelToPresent: PersistentModelRepresentable? { get set }
    
    func fetchEmojis()
    func fetchRandomEmoji()
    func searchUser()
}

class MainViewModel: MainViewModelInterface {
    
    let emojiAdapter: EmojiAdapterInterface
    let avatarAdapter: AvatarAdapterInterface
    @Published var error: Error?
    @Published var modelToPresent: PersistentModelRepresentable?
    @Published var nameQuery: String = String()
    @Published var state: ViewState = .initial
    
    private var disposableBag = Set<AnyCancellable>()
    
    init(
        emojiAdapter: EmojiAdapterInterface = EmojiAdapter(),
        avatarAdapter: AvatarAdapterInterface = AvatarAdapter()
    ) {
        self.emojiAdapter = emojiAdapter
        self.avatarAdapter = avatarAdapter
        subscribeToAvatarRemovalNotification()
        fetchEmojis()
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
                    self.state = .idle
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
    
    func searchUser() {
        // TODO: - ensure that the field has data
        state = .loading
        Task {
            do {
                let user = try await avatarAdapter.fetch(user: nameQuery)
                await MainActor.run {
                    withAnimation {
                        self.nameQuery = String()
                        self.state = .idle
                        self.modelToPresent = user
                    }
                }
            } catch {
                await MainActor.run {
                    self.error = error
                    self.state = .idle
                }
            }
        }
    }
}

private extension MainViewModel {
    
    func subscribeToAvatarRemovalNotification() {
        NotificationCenter.default.publisher(for: .didRemoveAvatarFromPersistence)
            .compactMap { $0.object as? String }
            .sink { [weak self] avatarName in
                guard let self else { return }
                if modelToPresent?.name == avatarName {
                    modelToPresent = nil
                }
            }
            .store(in: &disposableBag)
    }
}
