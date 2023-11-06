import Foundation
import Combine

@propertyWrapper
struct Localized {
    private var value: String
    
    public init(wrappedValue: String) {
        value = NSLocalizedString(wrappedValue, comment: "")
    }
    
    public var wrappedValue: String {
        get { value }
        set {
            value = NSLocalizedString(newValue, comment: "")
        }
    }
}
