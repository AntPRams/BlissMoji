import Foundation

enum AppError: Error {
    case userNameMissing
}

extension AppError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .userNameMissing:
            return Localizable.userNameMissing
        }
    }
}
