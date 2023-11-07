import UIKit
import Combine

class ImageViewModel: ObservableObject {
    
    let repository: PersistentDataRepository
    @Published var item: MediaItem
    @Published var error: Error?
    @Published var state: ViewState = .initial
    @Published var image: UIImage = UIImage()
    
    private var disposableBag = Set<AnyCancellable>()
    
    init(
        item: MediaItem,
        repository: PersistentDataRepository = PersistentDataRepository(),
        shouldFetchImageOnInitialization: Bool = true
    ) {
        self.item = item
        self.repository = repository
        subscribeToDisplayedItemUpdateNotification()
        guard shouldFetchImageOnInitialization else { return }
        fetchImage(url: item.imageUrl)
    }
    
    func fetchImage(url: URL) {
        guard let image = item.image else {
            state = .loading
            Task {
                do {
                    let imageData = try await repository.fetchImage(with: url)
                    
                    await MainActor.run {
                        // We removed the image data set here
                        self.item.imageData = imageData
                        self.state = .idle
                        guard let itemImage = item.image else { return }
                        self.image = itemImage
                    }
                } catch {
                    await MainActor.run {
                        self.state = .idle
                    }
                }
            }
            return
        }
        self.image = image
    }
}

private extension ImageViewModel {
    func subscribeToDisplayedItemUpdateNotification() {
        NotificationCenter.default.publisher(for: .didUpdateDisplayedItem)
            .receive(on: DispatchQueue.main)
            .compactMap { $0.object as? MediaItem }
            .sink { [weak self] item in
                guard let self else { return }
                self.item = item
                fetchImage(url: item.imageUrl)
            }
        
            .store(in: &disposableBag)
    }
}
