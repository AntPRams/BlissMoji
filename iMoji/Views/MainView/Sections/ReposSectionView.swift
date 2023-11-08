import SwiftUI

struct ReposSectionView: View {
    var body: some View {
        NavigationLink(destination: {
            ListView(viewModel: ListViewModel())
        }, label: {
            Text(Localizable.appleReposButton)
                .frame(maxWidth: .infinity)
        })
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    ReposSectionView()
}
