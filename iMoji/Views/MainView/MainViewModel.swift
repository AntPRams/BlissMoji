import Foundation
import SwiftUI
import Combine

class MainViewModel: ObservableObject {
    
    let repository: PersistentDataRepository
    @Published var error: Error?
    @Published var displayedItem: MediaItem?
    @Published var nameQuery: String = String()
    @Published var state: ViewState = .initial
    
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
            do {
                let emoji = try await repository.fetchRandomEmoji()
                await MainActor.run {
                    withAnimation {
                        self.displayedItem = emoji
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
    
    func searchUser() {
        // TODO: - ensure that the field has data
        state = .loading
        Task {
            do {
                let user = try await repository.fetchAvatar(user: nameQuery)
                await MainActor.run {
                    withAnimation {
                        self.nameQuery = String()
                        self.state = .idle
                        self.displayedItem = user
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
                if displayedItem?.name == avatarName {
                    displayedItem = nil
                }
            }
            .store(in: &disposableBag)
    }
}
