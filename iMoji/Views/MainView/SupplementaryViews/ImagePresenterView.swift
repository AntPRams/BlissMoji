import SwiftUI

struct ImagePresenterView: View {
    
    let viewModel: MainViewModel
    
    var body: some View {
        ZStack {
            ContainerRelativeShape()
                .inset(by: 4)
                .fill(.clear)
            presentProgressView(basedOn: viewModel.viewState)
        }
        .clipShape(Capsule())
        .frame(maxWidth: .infinity)
        .frame(height: 120)
    }
    
    @ViewBuilder
    private func presentProgressView(basedOn viewState: ViewState) -> some View {
        if viewState == .loading {
            ProgressView()
        } else if let item = viewModel.displayedItem {
            ImageView(viewModel: ImageViewModel(item: item))
        }
    }
}

#Preview {
    ImagePresenterView(viewModel: MainViewModel())
}
