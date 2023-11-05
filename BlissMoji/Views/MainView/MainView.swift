import SwiftUI

struct MainView<ViewModel: MainViewModelInterface>: View {
    
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.state == .loading {
                    ZStack {
                        ProgressView()
                        Rectangle()
                            .frame(width: 80, height: 80)
                    }
                } else if viewModel.state == .idle {
                    if let randomEmoji = viewModel.randomEmoji {
                        EmojiView(viewModel: EmojiViewModel(emojiModel: randomEmoji)) {}
                    }
                }
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
                    Text("Emojis list")
                        .frame(maxWidth: .infinity)
                })
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal, 16)
            .navigationTitle("BlissMoji")
        }
    }
}

#Preview {
    return MainView(viewModel: MainViewModel())
}
