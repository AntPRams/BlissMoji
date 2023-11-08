import Foundation
import Combine

@Observable class MainViewModel {
    
    let repository: PersistentDataRepository
    var error: Error?
    var displayedItem: MediaItem?
    var nameQuery: String = String()
    var state: ViewState = .initial
    
    private var disposableBag = Set<AnyCancellable>()
    
    init(repository: PersistentDataRepository = PersistentDataRepository()) {
        self.repository = repository
        subscribeToAvatarRemovalNotification()
        fetchEmojis()
    }
    
    func fetchEmojis() {
        state = .loading
        Task {
            do {
                try await repository.fetchItems(.emoji)
                await MainActor.run {
                    self.state = .idle
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
            do {
                let emoji = try await repository.fetchRandomEmoji()
                await MainActor.run {
                    self.displayedItem = emoji
                    self.state = .idle
                }
            } catch {
                await MainActor.run {
                    self.error = error
                    self.state = .idle
                }
            }
        }
    }
    
    func searchUser() {
        // TODO: - ensure that the field has data
        state = .loading
        Task {
            do {
                let user = try await repository.fetchAvatar(user: nameQuery)
                await MainActor.run {
                    self.nameQuery = String()
                    self.state = .idle
                    self.displayedItem = user
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
                if displayedItem?.name == avatarName {
                    displayedItem = nil
                }
            }
            .store(in: &disposableBag)
    }
}
