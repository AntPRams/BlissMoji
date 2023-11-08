import Foundation
import Combine

/// A property wrapper for localizing string values in your code.
///
/// Usage:
///
/// ```swift
/// @Localized("Some_localized_string_identifier") var localizedString
/// ```
///
/// In the above example, the `greeting` string will be localized based on the application's language settings.
///
/// - Note: This property wrapper was taken from: https://github.com/globulus/swift-property-wrappers/blob/main/Sources/SwiftPropertyWrappers/Localized.swift
@propertyWrapper
struct Localized {
    private var value: String
    private let subject = PassthroughSubject<String, Never>()
    
    public init(_ wrappedValue: String) {
        value = NSLocalizedString(wrappedValue, comment: "")
    }
    
    public var wrappedValue: String {
        get { value }
        set {
            value = NSLocalizedString(newValue, comment: "")
        }
    }
    
    public var projectedValue: AnyPublisher<String, Never> {
        subject.eraseToAnyPublisher()
    }
}
