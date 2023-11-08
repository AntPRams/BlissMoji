import Foundation

/// The `EndPoint` enum defines different types of endpoints that can be used to make network requests.
enum EndPoint {
    case emojis
    case avatar(user: String)
    case repositories(user: String, page: Int, size: Int = 10)
    
    /// Returns the `URL` corresponding to the specific endpoint.
    var url: URL? {
        switch self {
        case .emojis:
            return EndPoint.url("/emojis")
        case .avatar(let user):
            return EndPoint.url("/users/\(user)")
        case .repositories(let user, let page, let size):
            let page = URLQueryItem(name: "page", value: "\(page)")
            let size = URLQueryItem(name: "per_page", value: "\(size)")
            return EndPoint.url("/users/\(user)/repos", queryItems: [page, size])
        }
    }
}

extension EndPoint {
    /// Constructs a `URL` based on the given path and optional query items.
    ///
    /// - Parameters:
    ///   - path: The path component of the `URL`.
    ///   - queryItems: Optional query items to include in the `URL`.
    ///
    /// - Returns: The constructed `URL`.
    static private func url(_ path: String, queryItems: [URLQueryItem]? = nil) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        components.path = path
        components.queryItems = queryItems
        
        return components.url
    }
}

