//
//  SearchFieldView.swift
//  iMoji
//
//  Created by António Ramos on 06/11/2023.
//

import SwiftUI

struct SearchFieldView: View {
    
    @ObservedObject var viewModel: MainViewModel
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack {
            TextField(Localizable.searchFieldViewPlaceholder, text: $viewModel.nameQuery)
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
            .disabled(viewModel.state == .loading)
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    SearchFieldView(viewModel: MainViewModel())
}
