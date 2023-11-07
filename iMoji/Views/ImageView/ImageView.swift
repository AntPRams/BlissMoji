import SwiftUI

struct ImageView: View {
    
    let viewModel: ImageViewModel
    
    var body: some View {
        ZStack {
            if viewModel.state == .loading {
                ProgressView()
            }
            Image(uiImage: viewModel.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    ImageView(
        viewModel: ImageViewModel(item: MediaItem(name: "", imageUrl: URL(string: "")!, type: ItemType.emoji.rawValue)))
}
