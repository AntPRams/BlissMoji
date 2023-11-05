import SwiftUI
import SwiftData

@main
struct BlissMojiApp: App {
    var body: some Scene {
        WindowGroup {
            MainView(viewModel: MainViewModel())
        }
    }
}
