import SwiftUI
import SwiftData

@main
struct iMojiApp: App {
    var body: some Scene {
        WindowGroup {
            MainView(viewModel: MainViewModel())
        }
    }
}
