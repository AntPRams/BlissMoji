import SwiftUI

struct SearchFieldView: View {
    
    @Bindable var viewModel: MainViewModel
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack {
            TextField(Localizable.searchFieldViewPlaceholder, text: $viewModel.query)
                .textFieldStyle(.roundedBorder)
                .focused($isFocused)
                .autocorrectionDisabled()
            Button {
                viewModel.searchUser()
                isFocused = false
            } label: {
                Image(systemName: "magnifyingglass")
            }
            .buttonStyle(.borderedProminent)
        }
        .allowsHitTesting(viewModel.viewState != .loading)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    SearchFieldView(viewModel: MainViewModel())
}
