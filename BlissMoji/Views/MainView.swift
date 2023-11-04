import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        NavigationStack {
            VStack {
                EmojiView(name: "apple")
                Button {
                    fetchData()
                } label: {
                    Text(Localizable.emojisButton)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                NavigationLink(destination: {
                    EmojisListView()
                }, label: {
                    Text("Emojis list")
                        .frame(maxWidth: .infinity)
                })
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal, 16)
            .navigationTitle("BlissMoji")
        }
    }
    
    func fetchData() {
        Task {
            do {
                let adapter = EmojiAdapter(modelContext: modelContext)
                let emojis = try await adapter.fetchEmojisData()
                await MainActor.run {
                    emojis.forEach {
                        print($0.name)
                    }
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
