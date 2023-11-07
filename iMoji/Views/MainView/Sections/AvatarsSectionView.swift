import SwiftUI

struct AvatarsSectionView<ViewModel: MainViewModelInterface>: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            SearchFieldView(viewModel: viewModel)
            NavigationLink(destination: {
                ImagesGridView(viewModel: ImagesGridViewModel(gridDataType: .avatars))
            }, label: {
                Text(Localizable.avatarsList)
                    .frame(maxWidth: .infinity)
            })
            .buttonStyle(.borderedProminent)
            Divider()
                .padding(.vertical, 16)
        }
    }
}

#Preview {
    AvatarsSectionView(viewModel: MainViewModel())
}
