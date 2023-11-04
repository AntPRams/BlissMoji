import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        VStack {
            Image(uiImage: UIImage())
                .clipShape(.circle)
            Button {
                fetchData()
            } label: {
                Text(Localizable.emojisButton)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(.horizontal, 16)
    }
    
    func fetchData() {
        Task {
            do {
                let adapter = EmojiAdapter(modelContext: modelContext)
                let emojis = try await adapter.fetchEmojisData()
                await MainActor.run {
                    print(emojis)
                }
            } catch {
                await MainActor.run {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

#Preview {
    MainView()
}
