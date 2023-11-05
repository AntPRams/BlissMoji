//
//  EmojisListView.swift
//  BlissMoji
//
//  Created by António Ramos on 04/11/2023.
//

import SwiftUI
import SwiftData
import Combine

struct EmojisListView<ViewModel: EmojisListViewModelInterface>: View {
    
    var data = [EmojiModel]()
    @StateObject var viewModel: ViewModel
    
    let columns = [
        GridItem(.adaptive(minimum: 100))
            
    ]
    
    var body: some View {
        ScrollView {
            if viewModel.emojis.isNotEmpty {
                LazyVGrid(columns: columns, content: {
                    ForEach(Array(viewModel.emojis.enumerated()), id: \.1) { (i, emoji) in
                        EmojiView(viewModel: EmojiViewModel(emojiModel: emoji)) {
                            viewModel.emojis.remove(at: i)
                        }
                    }
                })
            }
        }
        .refreshable {
            viewModel.fetchEmojis()
        }
    }
    
    func removeModel(at offsets: IndexSet) {
        viewModel.emojis.remove(atOffsets: offsets)
    }
}

#Preview {
    EmojisListView(viewModel: EmojisListViewModel())
}
