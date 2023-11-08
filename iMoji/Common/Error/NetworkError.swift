import Foundation

/// An enum representing network-related errors with localized descriptions.
enum NetworkError: Error {
    case redirected
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case serverError
    case noData
    case unknown
}

extension NetworkError: LocalizedError {
    /// A localized description for the network error.
    public var errorDescription: String? {
        switch self {
        case .redirected:
            return Localizable.networkErrorBadRequest
        case .badRequest:
            return Localizable.networkErrorBadRequest
        case .unauthorized, .forbidden:
            return Localizable.networkErrorUnauthorized
        case .notFound:
            return Localizable.networkErrorNotFound
        case .serverError:
            return Localizable.networkError500GenericMessage
        case .noData:
            return Localizable.networkErrorNoData
        case .unknown:
            return Localizable.networkErrorUnknown
        }
    }
}
