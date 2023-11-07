import SwiftUI

struct AvatarsSectionView: View {
    
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        VStack {
            SearchFieldView(viewModel: viewModel)
            NavigationLink(destination: {
                ImagesGridView(viewModel: ImagesGridViewModel(gridDataType: .avatar))
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
