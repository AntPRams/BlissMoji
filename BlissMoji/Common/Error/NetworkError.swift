import Foundation

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
    public var errorDescription: String? {
        switch self {
        case .redirected:
            return ""
        case .badRequest:
            return ""
        case .unauthorized, .forbidden:
            return ""
        case .notFound:
            return ""
        case .serverError:
            return ""
        case .noData:
            return ""
        case .unknown:
            return ""
        }
    }
}

