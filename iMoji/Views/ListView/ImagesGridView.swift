import SwiftUI
import SwiftData
import Combine

struct ImagesGridView<ViewModel: ImagesGridViewModelInterface>: View {
    
    var data = [EmojiModel]()
    @StateObject var viewModel: ViewModel
    
    let columns = [
        GridItem(.adaptive(minimum: 100))
            
    ]
    
    var body: some View {
        ScrollView {
            if viewModel.emojis.isNotEmpty {
                LazyVGrid(columns: columns, content: {
                    ForEach(Array(viewModel.emojis.enumerated()), id: \.1) { (i, emoji) in
                        ImageView(viewModel: ImageViewModel(model: emoji)) {
                            viewModel.emojis.remove(at: i)
                        }
                    }
                })
            }
        }
        .refreshable {
            viewModel.fetchEmojis()
        }
        .errorAlert(error: $viewModel.error)
    }
    
    func removeModel(at offsets: IndexSet) {
        viewModel.emojis.remove(atOffsets: offsets)
    }
}

#Preview {
    ImagesGridView(viewModel: ImagesGridViewModel())
}
