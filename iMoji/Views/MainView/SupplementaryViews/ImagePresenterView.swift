import SwiftUI

struct ImagePresenterView: View {
    
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        ZStack {
            ContainerRelativeShape()
                .inset(by: 4)
                .fill(.clear)
            if viewModel.state == .loading {
                ProgressView()
            }
            if let item = viewModel.displayedItem {
                ImageView(viewModel: ImageViewModel(item: item))
            }
        }
        .clipShape(Capsule())
        .frame(maxWidth: .infinity)
        .frame(height: 120)
    }
}

#Preview {
    ImagePresenterView(viewModel: MainViewModel())
}
