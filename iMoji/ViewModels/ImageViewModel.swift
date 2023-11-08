import UIKit

@Observable 
class ImageViewModel {
    
    // MARK: - Properties
    
    let repository: PersistentDataRepositoryInterface
    var item: MediaItem
    var image: UIImage = UIImage()
    var viewState: ViewState = .initial
    var error: Error?
    
    // MARK: - Init
    
    init(
        item: MediaItem,
        repository: PersistentDataRepositoryInterface = PersistentDataRepository(),
        shouldFetchImageOnInitialization: Bool = true
    ) {
        self.item = item
        self.repository = repository
        guard shouldFetchImageOnInitialization else { return }
        fetchImage(url: item.imageUrl)
    }
    
    // MARK: - Public Interface
    
    func fetchImage(url: URL) {
        guard let image = item.image else {
            viewState = .loading
            Task { [weak self] in
                guard let self else { return }
                do {
                    let imageData = try await repository.fetchImage(with: url)
                    await MainActor.run {
                        self.item.imageData = imageData
                        self.viewState = .idle
                        guard let itemImage = self.item.image else { return }
                        self.image = itemImage
                    }
                } catch {
                    await MainActor.run {
                        self.viewState = .idle
                    }
                }
            }
            return
        }
        self.image = image
    }
}
