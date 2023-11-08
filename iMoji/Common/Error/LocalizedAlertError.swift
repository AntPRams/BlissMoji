import Foundation

/// A structure that adapts errors conforming to the `LocalizedError` for use with `errorAlert(error:buttonTitle:)`.
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
