/// An extension on the Collection protocol that grants a safe access to elements by index.
///
/// - Note: This method was taken from: https://stackoverflow.com/a/30593673/12060732
extension Collection {
    /// Safely returns an element at the specified index.
    /// It checks if the index is within the valid  index of the collection and returns the element if it is, or `nil` if the index is out of bounds.
    ///
    /// - Parameter index: The index at which to access the element.
    /// - Returns: The element at the spcified index if it is within bounds, otherwise `nil`.
    ///
    /// Usage:
    ///
    /// ```swift
    /// let myArray = [1, 2, 3, 4, 5]
    /// let element = myArray[safe: 2] // returns 3
    /// let invalidElement = myArray[safe: 10] // returns nil
    /// ```
    ///
    /// - Note: This subscript extension is a convenient way to avoid index out-of-bounds errors when accessing elements in a collection.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

