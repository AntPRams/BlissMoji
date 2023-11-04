import SwiftUI

struct EmojiView: View {
    
    @State private var image: UIImage = UIImage()
    @Environment(\.modelContext) var modelContext
    var name: String
    var adapter: EmojiAdapter {
        EmojiAdapter(modelContext: modelContext)
    }
    
    var body: some View {
        VStack {
            Image(uiImage: image)
            Text(name)
        }
        .task {
            do {
                guard let imageData = try await adapter.fetchImage(with: name) else {
                    return
                }
                image = imageData
                
            } catch {
                print("error")
            }
        }
    }
}
