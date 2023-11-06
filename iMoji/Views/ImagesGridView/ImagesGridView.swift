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
        VStack {
            if viewModel.gridDataType == .avatars {
                Text(Localizable.navTitle)
            }
            ScrollView {
                if viewModel.data.isNotEmpty {
                    LazyVGrid(columns: columns, content: {
                        ForEach(Array(viewModel.data.enumerated()), id: \.1) { (i, element) in
                            if let model = element as? PersistentModelRepresentable {
                                ImageView(viewModel: ImageViewModel(model: model)) {
                                    viewModel.data.remove(at: i)
                                }
                            }
                        }
                    })
                }
            }
        }
        .onAppear(perform: viewModel.fetchData)
        .refreshable {
            viewModel.fetchData()
        }
        .errorAlert(error: $viewModel.error)
    }
    
    func removeModel(at offsets: IndexSet) {
        viewModel.data.remove(atOffsets: offsets)
    }
}

#Preview {
    ImagesGridView(viewModel: ImagesGridViewModel(gridDataType: .avatars))
}

#Preview {
    ImagesGridView(viewModel: ImagesGridViewModel(gridDataType: .emojis))
}
