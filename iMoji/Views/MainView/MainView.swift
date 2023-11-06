import SwiftUI

struct MainView<ViewModel: MainViewModelInterface>: View {
    
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                ImagePresenterView(viewModel: viewModel)
                EmojisSectionView(viewModel: viewModel)
                AvatarsSectionView(viewModel: viewModel)
                Spacer()
            }
            .padding(.horizontal, 16)
            .navigationTitle(Localizable.navTitle)
            .errorAlert(error: $viewModel.error)
        }
    }
}

#Preview {
    return MainView(viewModel: MainViewModel())
}
