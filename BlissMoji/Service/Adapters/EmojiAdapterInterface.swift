import Foundation

/// The `EmojiAdapterInterface` protocol defines the interface for an adapter responsible for fetching and handling emoji data and images.
protocol EmojiAdapterInterface {
    /// Initializes an `EmojiAdapter` with a provided service conforming to the `Service` protocol.
    ///
    /// - Parameter service: An instance conforming to the `Service` protocol used for fetching data and images.
    init(service: any Service)
    
    /// Asynchronously fetches a list of emoji data and converts it to an array of `EmojiModel` objects.
    ///
    /// - Returns: An array of `EmojiModel` objects representing the fetched emoji data.
    ///
    /// - Throws: An error if the data fetching operation encounters a problem.
    func fetchEmojisData() async throws -> [EmojiModel]
    
    /// Asynchronously fetches a random emoji from the available emoji data.
    ///
    /// - Returns: A randomly selected `EmojiModel` object.
    ///
    /// - Throws: An error if there are no emojis available or if the data fetching operation encounters a problem.
    func fetchRandomEmoji() async throws -> EmojiModel
    
    /// Asynchronously fetches the image data associated with a given `EmojiModel`.
    ///
    /// - Parameters:
    ///   - emoji: The `EmojiModel` for which the image is to be fetched.
    ///
    /// - Returns: The binary image data as `Data`.
    ///
    /// - Throws: An error if the image fetching operation encounters a problem.
    func fetchImage(for emoji: EmojiModel) async throws -> Data
}
