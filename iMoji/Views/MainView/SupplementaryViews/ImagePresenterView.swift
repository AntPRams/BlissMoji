import SwiftUI

struct ImagePresenterView: View {
    
    let viewModel: MainViewModel
    
    var body: some View {
        ZStack {
            ContainerRelativeShape()
                .inset(by: 4)
                .fill(.clear)
            if viewModel.viewState == .loading {
                ProgressView()
            } else if let item = viewModel.displayedItem {
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
