import SwiftUI

struct EmojisSectionView<ViewModel: MainViewModelInterface>: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            ImagePresenterView(viewModel: viewModel)
            Button {
                viewModel.fetchRandomEmoji()
            } label: {
                Text(Localizable.emojisButton)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            NavigationLink(destination: {
                EmojisListView(viewModel: EmojisListViewModel())
            }, label: {
                Text(Localizable.emojisList)
                    .frame(maxWidth: .infinity)
            })
            .buttonStyle(.borderedProminent)
            Divider()
        }
        .onAppear {
            viewModel.fetchEmojis()
        }
    }
}

#Preview {
    EmojisSectionView(viewModel: MainViewModel())
}
