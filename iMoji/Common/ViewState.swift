/// The `ViewState` enum represents different states of a view or component, typically used to manage the user interface based on the current state.
enum ViewState {
    /// The initial state, used to set up the view's initial configuration.
    case initial
    /// The loading state, indicating that the view is in the process of fetching or processing data.
    case loading
    /// The idle state, representing a state where the view is not actively performing any tasks.
    case idle
}
