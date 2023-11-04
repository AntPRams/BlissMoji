import SwiftUI
import SwiftData

@main
struct BlissMojiApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(for: EmojiModel.self)
    }
}
