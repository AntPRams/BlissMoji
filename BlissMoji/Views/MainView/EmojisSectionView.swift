//
//  EmojisSectionView.swift
//  BlissMoji
//
//  Created by António Ramos on 06/11/2023.
//

import SwiftUI

struct EmojisSectionView<ViewModel: MainViewModelInterface>: View {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            ZStack {
                ContainerRelativeShape()
                    .inset(by: 4)
                    .fill(.clear)
                if viewModel.state == .loading {
                    ProgressView()
                } else if viewModel.state == .idle {
                    if let randomEmoji = viewModel.randomEmoji {
                        EmojiView(viewModel: EmojiViewModel(emojiModel: randomEmoji)) {}
                    }
                }
            }
            .clipShape(Capsule())
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            Button {
                viewModel.fetchRandomEmoji()
            } label: {
                Text(Localizable.emojisButton)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            NavigationLink(destination: {
                EmojisListView(viewModel: EmojisListViewModel())
            }, label: {
                Text("Emojis list")
                    .frame(maxWidth: .infinity)
            })
            .buttonStyle(.borderedProminent)
            Divider()
        }
    }
}

#Preview {
    EmojisSectionView(viewModel: MainViewModel())
}
