import SwiftUI

struct ListFooterView: View {
    
    let viewModel: ListViewModel
    
    var body: some View {
        ZStack(alignment: .center) {
            switch viewModel.viewState {
            case .idle, .initial:
                EmptyView()
            case .loading:
                ProgressView()
            }
        }
        .frame(height: 50)
        .onAppear {
            viewModel.fetchRepos()
        }
    }
}

#Preview {
    ListFooterView(viewModel: ListViewModel())
}
