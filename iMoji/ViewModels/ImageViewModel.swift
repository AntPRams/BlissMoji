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
        fetchImage()
    }
    
    // MARK: - Public Interface
    
    func fetchImage() {
        guard let image = item.image else {
            viewState = .loading
            Task { [weak self] in
                guard let self else { return }
                do {
                    let imageData = try await repository.fetchImage(for: item)
                    await MainActor.run {
                        self.viewState = .idle
                        guard let itemImage = UIImage(data: imageData) else { return }
                        self.image = itemImage
                    }
                } catch {
                    await MainActor.run {
                        self.error = error
                        self.viewState = .idle
                    }
                }
            }
            return
        }
        self.image = image
    }
}
