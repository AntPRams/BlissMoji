import UIKit
import Combine

@Observable class ImageViewModel {
    
    let repository: PersistentDataRepository
    var item: MediaItem
    var error: Error?
    var state: ViewState = .initial
    var image: UIImage = UIImage()
    
    private var disposableBag = Set<AnyCancellable>()
    
    init(
        item: MediaItem,
        repository: PersistentDataRepository = PersistentDataRepository(),
        shouldFetchImageOnInitialization: Bool = true
    ) {
        self.item = item
        self.repository = repository
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
