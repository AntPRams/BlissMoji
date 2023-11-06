import SwiftUI

struct MainView<ViewModel: MainViewModelInterface>: View {
    
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                EmojisSectionView(viewModel: viewModel)
            }
            .padding(.horizontal, 16)
            .navigationTitle("BlissMoji")
            Spacer()
        }
    }
}

#Preview {
    return MainView(viewModel: MainViewModel())
}
