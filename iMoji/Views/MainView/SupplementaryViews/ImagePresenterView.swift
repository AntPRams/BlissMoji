import SwiftUI

struct ImagePresenterView<ViewModel: MainViewModelInterface>: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        ZStack {
            ContainerRelativeShape()
                .inset(by: 4)
                .fill(.clear)
            if viewModel.state == .loading {
                ProgressView()
            } else if viewModel.state == .idle {
                if let randomEmoji = viewModel.modelToPresent {
                    ImageView(
                        viewModel: ImageViewModel(model: randomEmoji),
                        deleteAction: {}
                    )
                }
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
