/// An extension for the Array data type to provide a computed property for checking if the array is not empty.
extension Array {
    /// A Boolean property that simplifies checking if the array has elements.
    ///
    /// Instead of using negation like `!someArray.isEmpty`, you can use `someArray.isNotEmpty` for a more intuitive check.
    public var isNotEmpty: Bool {
        !isEmpty
    }
}
