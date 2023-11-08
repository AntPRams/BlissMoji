import SwiftUI

struct ListView: View {
    
    @Bindable var viewModel: ListViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.reposData, id: \.id) { repo in
                if let name = repo.name {
                    ListItemView(repoName: name)
                }
            }
            presentFooter(if: viewModel.isMoreDataAvailable)
        }
        .errorAlert(error: $viewModel.error)
    }
    
    @ViewBuilder
    private func presentFooter(if moreDataIsAvailable: Bool) -> some View {
        if moreDataIsAvailable {
            ListFooterView(viewModel: viewModel)
        } else {
            EmptyView()
        }
    }
}

#Preview {
    ListView(viewModel: ListViewModel())
}
