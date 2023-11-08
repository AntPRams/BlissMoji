extension Array {
    public var isNotEmpty: Bool {
        !isEmpty
    }
}

//Taken from https://stackoverflow.com/a/30593673/12060732
extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

