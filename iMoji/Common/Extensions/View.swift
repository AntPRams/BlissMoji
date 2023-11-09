import SwiftUI

/// An extension that adds a method for presenting error alerts
extension View {
    /// Presents an alert for displaying an error message and an optional action button.
    ///
    /// - Parameters:
    ///   - error: A binding to an optional Error instance. The alert will be shown if the error is non-nil.
    ///   - buttonTitle: The title of the action button (default is "OK").
    /// - Returns: A modified view that presenst the error alert.
    ///
    /// This method creates an alert to display an error message based on the provided `error`binding. If the `error` is non-nil, the alert will be presented. The alert can include a button with a customizable title.
    ///
    /// - Note: This method simplifies the process of presenting error alerts within SwiftUI views.
    func errorAlert(
        error: Binding<Error?>,
        buttonTitle: String = Localizable.buttonOk
    ) -> some View {
        let localizedAlertError = LocalizedAlertError(error: error.wrappedValue)
        
        return alert(isPresented: .constant(localizedAlertError != nil), error: localizedAlertError) { _ in
            Button(buttonTitle) {
                error.wrappedValue = nil
            }
        } message: { error in
            Text(error.recoverySuggestion ?? "")
        }
    }
    
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    ///
    /// - Note: Taken from here https://www.avanderlee.com/swiftui/conditional-view-modifier/
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
