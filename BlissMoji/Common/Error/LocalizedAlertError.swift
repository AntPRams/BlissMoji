import Foundation

struct LocalizedAlertError: LocalizedError {
    
    // MARK: - Properties
    
    let underlyingError: LocalizedError
    var errorDescription: String? {
        underlyingError.errorDescription
    }
    
    // MARK: - Init

    init?(error: Error?) {
        guard let localizedError = error as? LocalizedError else { return nil }
        underlyingError = localizedError
    }
}
