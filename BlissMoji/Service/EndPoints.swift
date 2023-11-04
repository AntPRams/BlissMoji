import Foundation

enum EndPoints {
    case emojis
    case avatar(user: String)
    case repos(user: String, page: Int, size: Int = 10)
    
    var url: URL? {
        switch self {
        case .emojis:
            return EndPoints.url("emojis")
        case .avatar(let user):
            return EndPoints.url("users/\(user)")
        case .repos(let user, let page, let size):
            let page = URLQueryItem(name: "page", value: "\(page)")
            let size = URLQueryItem(name: "per_page", value: "\(size)")
            return EndPoints.url("users/\(user)", queryItems: [page, size])
        }
    }
}

extension EndPoints {
    static private func url(_ path: String, queryItems: [URLQueryItem]? = nil) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        components.path = path
        components.queryItems = queryItems
        
        return components.url
    }
}

