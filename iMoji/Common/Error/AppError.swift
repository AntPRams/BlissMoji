import Foundation

/// An enum representing app-related errors with localized descriptions.
enum AppError: Error {
    case userNameMissing
}

extension AppError: LocalizedError {
    
    /// A localized description for the app error.
    public var errorDescription: String? {
        switch self {
        case .userNameMissing:
            return Localizable.userNameMissing
        }
    }
}
