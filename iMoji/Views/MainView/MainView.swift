import SwiftUI

struct MainView: View {
    
    @StateObject var viewModel: MainViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                ImagePresenterView(viewModel: viewModel)
                EmojisSectionView(viewModel: viewModel)
                AvatarsSectionView(viewModel: viewModel)
                Spacer()
                Button {
                    
                } label: {
                    Text(Localizable.buttonOk)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.red)
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
