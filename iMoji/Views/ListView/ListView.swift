import SwiftUI

struct ListView: View {
    
    let viewModel: ListViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.reposData, id: \.id) { repo in
                if let name = repo.name {
                    ListItemView(repoName: name)
                }
            }
            if viewModel.moreDataAvailable {
                ListFooterView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    ListView(viewModel: ListViewModel())
}
