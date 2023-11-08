import SwiftUI

struct MainView: View {
    
    @Bindable var viewModel: MainViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                ImagePresenterView(viewModel: viewModel)
                EmojisSectionView(viewModel: viewModel)
                AvatarsSectionView(viewModel: viewModel)
                ReposSectionView()
                Spacer()
            }
            .padding(16)
            .navigationTitle(Localizable.navTitle)
            .errorAlert(error: $viewModel.error)
        }
    }
}

#Preview {
    MainView(viewModel: MainViewModel())
}
