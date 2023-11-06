import SwiftUI

struct EmojisSectionView<ViewModel: MainViewModelInterface>: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            Button {
                viewModel.fetchRandomEmoji()
            } label: {
                Text(Localizable.emojisButton)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.state == .loading)
            NavigationLink(destination: {
                EmojisListView(viewModel: EmojisListViewModel())
            }, label: {
                Text(Localizable.emojisList)
                    .frame(maxWidth: .infinity)
            })
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.state == .loading)
            Divider()
                .padding(.vertical, 16)
        }
        .onAppear {
            viewModel.fetchEmojis()
        }
    }
}

#Preview {
    EmojisSectionView(viewModel: MainViewModel())
}
