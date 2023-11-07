import SwiftUI
import SwiftData
import Combine

struct ImagesGridView<ViewModel: ImagesGridViewModelInterface>: View {
    
    var data = [EmojiModel]()
    @StateObject var viewModel: ViewModel
    
    let columns = [
        GridItem(.adaptive(minimum: 80))
            
    ]
    
    var body: some View {
        VStack {
            if viewModel.gridDataType == .avatars {
                Text(Localizable.avatarsGridTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.bottom, .horizontal], 16)
            }
            ScrollView {
                if viewModel.data.isNotEmpty {
                    LazyVGrid(columns: columns) {
                        ForEach(Array(viewModel.data.enumerated()), id: \.1) { (i, element) in
                            if let model = element as? PersistentModelRepresentable {
                                ImageView(viewModel: ImageViewModel(model: model)) {
                                    viewModel.removeElement(at: i)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: viewModel.fetchData)
        .refreshable {
            viewModel.fetchData()
        }
        .errorAlert(error: $viewModel.error)
    }
}

#Preview {
    ImagesGridView(viewModel: ImagesGridViewModel(gridDataType: .avatars))
}

#Preview {
    ImagesGridView(viewModel: ImagesGridViewModel(gridDataType: .emojis))
}
