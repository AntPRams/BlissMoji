import SwiftUI

struct ImageView: View {
    
    let viewModel: ImageViewModel
    
    var body: some View {
        ZStack {
            showProgressView(basedOn: viewModel.viewState)
            Image(uiImage: viewModel.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
                .cornerRadius(14)
        }
        .padding(6)
        .cornerRadius(10) /// make the background rounded
        .overlay( /// apply a rounded border
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(uiColor: .systemGray6), lineWidth: 3)
        )
    }
    
    @ViewBuilder
    private func showProgressView(basedOn viewState: ViewState) -> some View {
        if viewState == .loading {
            ProgressView()
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    ImageView(
        viewModel: ImageViewModel(item: MediaItem(name: "", imageUrl: URL(string: "")!, type: ItemType.emoji.rawValue)))
}
