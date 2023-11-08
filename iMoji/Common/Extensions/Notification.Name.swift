import Foundation

extension Notification.Name {
    /// `Notification.Name` thats being used to post a notification warning the `MainViewModel` that an avatar has been removed
    static let didRemoveAvatarFromPersistence = Notification.Name("didRemoveAvatarFromPersistence")
}
