import SwiftUI
import SwiftData
import Combine

struct ImagesGridView: View {
    
    @StateObject var viewModel: ImagesGridViewModel
    
    let columns = [GridItem(.adaptive(minimum: 80))]
    
    var body: some View {
        VStack {
            if viewModel.gridDataType == .avatar {
                Text(Localizable.avatarsGridTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.bottom, .horizontal], 16)
            }
            ScrollView {
                if viewModel.data.isNotEmpty {
                    LazyVGrid(columns: columns) {
                        ForEach(Array(viewModel.data.enumerated()), id: \.1) { (i, item) in
                            ImageView(viewModel: ImageViewModel(item: item))
                                .onTapGesture {
                                    viewModel.removeElement(at: i)
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
    ImagesGridView(viewModel: ImagesGridViewModel(gridDataType: .avatar))
}

#Preview {
    ImagesGridView(viewModel: ImagesGridViewModel(gridDataType: .emoji))
}
